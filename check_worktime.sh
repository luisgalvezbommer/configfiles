#!/bin/bash
# /home/lgbo/Applications/check_worktime.sh
# Benötigt: timew, jq, notify-send, logger

USER_HOME="/home/lgbo"
export HOME="$USER_HOME"
export PATH="/usr/bin:/bin:/usr/local/bin"
export DISPLAY=":0"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

LOGGER_TAG="check_worktime"
TIMEW="/usr/bin/timew"
NOTIFY="/usr/bin/notify-send"
JQ="/usr/bin/jq"

# Konfiguration
DAILY_TARGET=$((8*3600))      # Extra‑Text bei >= 8 Stunden
WEEK_TARGET=$((40*3600))      # Wochenziel 40 Stunden

# Datei, die die zuletzt gemeldete volle Stunde speichert
LAST_HOUR_FILE="/tmp/check_worktime_last_hour_$(id -u)"

# Sekunden für einen Bereich berechnen (z. B. :day, :week)
seconds_for_range() {
  local range="$1"
  $TIMEW export "$range" 2>/dev/null | $JQ '[.[] 
    | select(.tags and (.tags | index("arbeit"))) 
    | (if .duration then .duration else (now - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime)) end)
  ] | add // 0 | floor'
}

# Pro‑Tag Summen der aktuellen Woche ausgeben: "YYYY-MM-DD seconds"
week_per_day() {
  $TIMEW export :week 2>/dev/null | $JQ -r '
    map(select(.tags and (.tags | index("arbeit")))) 
    | map(. as $it 
        | (if .duration then .duration else (now - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime)) end) as $dur
        | ($it.start | strptime("%Y%m%dT%H%M%SZ") | mktime) as $s
        | {date: (strftime("%Y-%m-%d"; localtime($s))), dur: $dur}
      )
    | group_by(.date) 
    | map({date: .[0].date, total: (map(.dur) | add)}) 
    | sort_by(.date)
    | .[] | "\(.date) \(.total|floor)"
  '
}

# Sekunden in H:MM format
format_hm() {
  local s=$1
  local h=$((s/3600))
  local m=$(((s%3600)/60))
  printf "%d:%02d" "$h" "$m"
}

# Stündliche Prüfung: nur benachrichtigen, wenn neue volle Stunde erreicht wurde
notify_on_new_full_hour() {
  local seconds_today hours_now last_hours now_ts
  seconds_today=$(seconds_for_range ":day")
  # Ganze Stunden (integer)
  hours_now=$((seconds_today / 3600))
  logger -t "$LOGGER_TAG" "Prüfung: $seconds_today Sekunden heute -> $hours_now volle Stunden"

  # Lese zuletzt gemeldete volle Stunde (default -1)
  if [ -f "$LAST_HOUR_FILE" ]; then
    last_hours=$(cat "$LAST_HOUR_FILE" 2>/dev/null || echo -1)
  else
    last_hours=-1
  fi

  # Wenn die Anzahl voller Stunden gestiegen ist und mindestens 1
  if [ "$hours_now" -gt "$last_hours" ] && [ "$hours_now" -ge 1 ]; then
    # Baue Nachricht
    local title="Arbeitszeit Update"
    local msg="Heute gearbeitet: $(format_hm "$seconds_today") (voller Stunden: ${hours_now}h)."
    if [ "$hours_now" -ge 8 ]; then
      msg="$msg  Tagesziel erreicht (≥ $(format_hm $DAILY_TARGET))."
    fi

    # Sende Notification
    $NOTIFY "$title" "$msg" 2>/dev/null
    if [ $? -eq 0 ]; then
      logger -t "$LOGGER_TAG" "Benachrichtigung gesendet: ${hours_now}h"
      # Update zuletzt gemeldete volle Stunde
      echo "$hours_now" > "$LAST_HOUR_FILE"
    else
      logger -t "$LOGGER_TAG" "notify-send fehlgeschlagen"
    fi
  else
    logger -t "$LOGGER_TAG" "Keine neue volle Stunde (aktuell: ${hours_now}h, zuletzt gemeldet: ${last_hours}h)"
  fi
}

# Tägliche Wochenübersicht (morgens/abends)
notify_daily_summary() {
  local lines week_total remaining day sec body
  lines=$(week_per_day)
  week_total=0
  body="Wochenübersicht:\n"
  while read -r line; do
    [ -z "$line" ] && continue
    day=$(echo "$line" | awk '{print $1}')
    sec=$(echo "$line" | awk '{print $2}')
    body="$body$day: $(format_hm $sec)\n"
    week_total=$((week_total + sec))
  done <<< "$lines"

  body="$body\nWochensumme: $(format_hm $week_total)\n"
  remaining=$((WEEK_TARGET - week_total))
  if [ "$remaining" -le 0 ]; then
    body="$body Verbleibend: 0 (Wochenziel erreicht)"
  else
    body="$body Verbleibend: $(format_hm $remaining) bis 40:00"
  fi

  $NOTIFY "Arbeitszeit Woche" "$body" 2>/dev/null
  if [ $? -eq 0 ]; then
    logger -t "$LOGGER_TAG" "Tägliche Wochenübersicht gesendet."
  else
    logger -t "$LOGGER_TAG" "notify-send fehlgeschlagen (daily summary)"
  fi
}

# Entrypunkt: "hourly" oder "daily"
case "$1" in
  hourly)
    notify_on_new_full_hour
    ;;
  daily)
    notify_daily_summary
    ;;
  *)
    notify_on_new_full_hour
    ;;
esac

exit 0
