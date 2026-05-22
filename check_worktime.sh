#!/bin/bash
# /home/lgbo/Applications/check_worktime.sh
# Requires: timew, jq, notify-send, logger

USER_HOME="/home/lgbo"
export HOME="$USER_HOME"
export PATH="/usr/bin:/bin:/usr/local/bin"
export DISPLAY=":0"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

LOGGER_TAG="check_worktime"
TIMEW="/usr/bin/timew"
NOTIFY="/usr/bin/notify-send"
JQ="/usr/bin/jq"

# Configuration
DAILY_TARGET=$((8*3600))      # Extra text at >= 8 hours
WEEK_TARGET=$((40*3600))      # Weekly target: 40 hours

# File that stores the last reported full hour
LAST_HOUR_FILE="/tmp/check_worktime_last_hour_$(id -u)"
DEBUG_MANUAL=0

# Detect manual invocations from a terminal (cron usually has no TTY)
is_manual_invocation() {
  [ -t 0 ] || [ -t 1 ]
}

# Calculate seconds for a range (e.g. :day, :week)
seconds_for_range() {
  local range="$1"
  $TIMEW export "$range" 2>/dev/null | $JQ '[.[] 
    | select(.tags and ((.tags | index("work")) or (.tags | index("arbeit")))) 
    | (if .duration then .duration
       elif (.start and .end) then ((.end | strptime("%Y%m%dT%H%M%SZ") | mktime) - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime))
       elif .start then (now - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime))
       else 0 end)
  ] | add // 0 | floor'
}

# Print per-day totals for the current week: "YYYY-MM-DD seconds"
week_per_day() {
  $TIMEW export :week 2>/dev/null | $JQ -r '
    map(select(.tags and ((.tags | index("work")) or (.tags | index("arbeit"))))) 
    | map(. as $it 
        | (if .duration then .duration
           elif (.start and .end) then ((.end | strptime("%Y%m%dT%H%M%SZ") | mktime) - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime))
           elif .start then (now - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime))
           else 0 end) as $dur
        | ($it.start | strptime("%Y%m%dT%H%M%SZ") | mktime) as $s
        | {date: ($s | localtime | strftime("%Y-%m-%d")), dur: $dur}
      )
    | group_by(.date) 
    | map({date: .[0].date, total: (map(.dur) | add)}) 
    | sort_by(.date)
    | .[] | "\(.date) \(.total|floor)"
  '
}

# Seconds in H:MM format
format_hm() {
  local s=$1
  local h=$((s/3600))
  local m=$(((s%3600)/60))
  printf "%d:%02d" "$h" "$m"
}

format_signed_hm() {
  local s=$1
  local sign=""

  if [ "$s" -lt 0 ]; then
    sign="-"
    s=$((-s))
  elif [ "$s" -gt 0 ]; then
    sign="+"
  fi

  local h=$((s/3600))
  local m=$(((s%3600)/60))
  printf "%s%d:%02d" "$sign" "$h" "$m"
}

format_percent() {
  local numerator=$1
  local denominator=$2
  local percent

  percent=$($JQ -nr --argjson n "$numerator" --argjson d "$denominator" '
    if $d == 0 then "0.00"
    else (((($n / $d) * 100) * 100 | floor) / 100 | tostring) end
  ')

  if [[ "$percent" != *.* ]]; then
    percent="${percent}.00"
  elif [[ "$percent" =~ \.[0-9]$ ]]; then
    percent="${percent}0"
  fi

  echo "$percent"
}

manual_debug_day() {
  $TIMEW :day summary
}

manual_debug_week() {
  $TIMEW :week summary
}

# Daily check: notify only when a new full hour is reached
notify_on_new_full_hour() {
  local force_notify seconds_today hours_now last_hours
  force_notify="${1:-0}"

  seconds_today=$(seconds_for_range ":day")
  if [ "$DEBUG_MANUAL" -eq 1 ]; then
    manual_debug_day
  fi
  # Full hours (integer)
  hours_now=$((seconds_today / 3600))
  logger -t "$LOGGER_TAG" "Check: $seconds_today seconds today -> $hours_now full hours"

  # Read last reported full hour (default -1)
  if [ -f "$LAST_HOUR_FILE" ]; then
    last_hours=$(cat "$LAST_HOUR_FILE" 2>/dev/null || echo -1)
  else
    last_hours=-1
  fi

  # For cron: notify only for a new full hour.
  # For manual invocation (force_notify=1): always notify.
  if [ "$force_notify" -eq 1 ] || { [ "$hours_now" -gt "$last_hours" ] && [ "$hours_now" -ge 1 ]; }; then
    # Build message
    local title="Worktime Update"
    local msg="Worked today: $(format_hm "$seconds_today") (full hours: ${hours_now}h)."

    if [ "$force_notify" -eq 1 ] && ! { [ "$hours_now" -gt "$last_hours" ] && [ "$hours_now" -ge 1 ]; }; then
      msg="$msg  (Manual status check)"
    fi

    if [ "$hours_now" -ge 8 ]; then
      msg="$msg  Daily target reached (>= $(format_hm $DAILY_TARGET))."
    fi

    # Send notification
    $NOTIFY "$title" "$msg" 2>/dev/null
    if [ $? -eq 0 ]; then
      logger -t "$LOGGER_TAG" "Notification sent: ${hours_now}h"
      # Update only when a new full hour was actually reached.
      if [ "$hours_now" -gt "$last_hours" ] && [ "$hours_now" -ge 1 ]; then
        echo "$hours_now" > "$LAST_HOUR_FILE"
      fi
    else
      logger -t "$LOGGER_TAG" "notify-send failed"
    fi
  else
    logger -t "$LOGGER_TAG" "No new full hour (current: ${hours_now}h, last reported: ${last_hours}h)"
  fi
}

# Weekly overview summary (morning/evening)
notify_weekly_summary() {
  local week_total day_number day_plan_seconds delta_day delta_week
  local week_hm day_plan_hm week_target_hm
  local percent_total percent_day_gap percent_week_gap body
  local abs_delta_day abs_delta_week
  if [ "$DEBUG_MANUAL" -eq 1 ]; then
    manual_debug_week
  fi

  week_total=$(seconds_for_range ":week")
  week_hm=$(format_hm "$week_total")
  week_target_hm=$(format_hm "$WEEK_TARGET")

  day_number=$(date +%u)
  day_plan_seconds=$((DAILY_TARGET * day_number))
  day_plan_hm=$(format_hm "$day_plan_seconds")

  delta_day=$((week_total - day_plan_seconds))
  delta_week=$((week_total - WEEK_TARGET))

  abs_delta_day=$delta_day
  if [ "$abs_delta_day" -lt 0 ]; then
    abs_delta_day=$((-abs_delta_day))
  fi

  abs_delta_week=$delta_week
  if [ "$abs_delta_week" -lt 0 ]; then
    abs_delta_week=$((-abs_delta_week))
  fi

  percent_total=$(format_percent "$week_total" "$WEEK_TARGET")
  percent_day_gap=$(format_percent "$abs_delta_day" "$day_plan_seconds")
  percent_week_gap=$(format_percent "$abs_delta_week" "$WEEK_TARGET")

  body="${week_hm}/${week_target_hm} (${percent_total}%) | $(format_signed_hm "$delta_day")/${day_plan_hm} (${percent_day_gap}%) | $(format_signed_hm "$delta_week")/${week_target_hm} (${percent_week_gap}%)"

  $NOTIFY "Weekly Overview" "$body" 2>/dev/null
  if [ $? -eq 0 ]; then
    logger -t "$LOGGER_TAG" "Weekly overview sent: $body"
  else
    logger -t "$LOGGER_TAG" "notify-send failed (weekly summary)"
  fi
}

# Entry point: "daily" or "weekly"
FORCE_NOTIFY=0
if [ "$2" = "--force" ]; then
  FORCE_NOTIFY=1
elif is_manual_invocation; then
  FORCE_NOTIFY=1
fi

if is_manual_invocation; then
  DEBUG_MANUAL=1
fi

case "$1" in
  daily)
    notify_on_new_full_hour "$FORCE_NOTIFY"
    ;;
  weekly)
    notify_weekly_summary
    ;;
  *)
    notify_on_new_full_hour "$FORCE_NOTIFY"
    ;;
esac

exit 0
