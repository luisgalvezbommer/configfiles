# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="robbyrussell"
#ZSH_THEME="heapbytes"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bundler
  dotenv
  macos
  rake
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "%F{yellow}(${ref#refs/heads/})%f"
}



PROMPT='%F{blue}%B%n@%m%f%b:%F{green}%B%~%f $(git_prompt_info)%b$ '

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias ls="lsd --group-dirs first"
alias ll="lsd -Alh --group-dirs first"
alias bat="batcat -P"
alias df="df -h"
alias re="grep -Hn"
alias ranger=". ranger"
alias ra=". ranger"

#alias cd="z"
#alias c="z"
#alias ubuntu="fastfetch"
alias reload="source ~/.zshrc"

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

#export TERMINAL="/usr/bin/kitty"
#export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"


#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
#zstyle ':completion:*' menu no
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#source <(fzf --zsh)
#source ~/.config/fzf/fzf-git.sh
#eval "$(zoxide init zsh)"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

autoload -U bashcompinit && bashcompinit
eval "$(pip completion --zsh)"
source /etc/zsh_command_not_found
export PATH=$PATH:/usr/local/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# Golang environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# Update PATH to include GOPATH and GOROOT binaries
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

alias fabric="~/fabric"
alias german="~/fabric -sp german"

summarize() {
  fabric -y $1 | fabric -sp summarize
}

extract_wisdom() {
  fabric -y $1 | fabric -sp extract_wisdom
}

export PATH="/usr/local/binaryen-122:$PATH"
export PATH=$PATH:/usr/local/go/bin

generate_tags() {
  # Standard-Ausgabedatei
  local output_file="tags.txt"

  # Wenn keine Argumente übergeben wurden, verwende '.' als Standard (aktuelles Verzeichnis)
  if [ $# -eq 0 ]; then
    set -- .
  fi

  # Schritt 1: Generiere tags_x.txt mit ctags
  ctags -x --fields=+KSn -f "$output_file" "$@"

  # Schritt 2: Sortieren und Leerzeilen einfügen (tags -> tags.tmp -> tags)
  awk 'BEGIN { prev = "" }
       {
         if ($4 != prev) {
           if (NR > 1) print "";
           prev = $4
         }
         print
       }' <(sort -k4,4 -k3,3n "$output_file") > "${output_file}.tmp"
  
  mv "${output_file}.tmp" "$output_file"

  echo "✅ Tags gespeichert in '$output_file'."
}

tags() {
  #  Z.b. tags /directory "*.py"
  local dir="${1:-.}"
  local pattern="${2:-*}"
  local -a files

  # Finde alle Dateien mit passendem Pattern
  IFS=$'\n' files=($(find "$dir" -name "$pattern"))

  # Optional: Zeige gefundene Dateien zur Kontrolle
  for f in "${files[@]}"; do
    echo "$f"
  done

  # Übergib alle Dateien als einzelne Argumente
  generate_tags "${files[@]}"
}

tags2puml() {
  python3 ~/code/tags2puml/tags2puml.py "$1"
}


gemmit() {
  source ~/code/VirtualEnv/.venv-genai/bin/activate
  python3 ~/code/gemmit/gemmit.py $1
  deactivate
}

praat() {
  export GTK_THEME=Adwaita praat
  ./praat
}

alias kubectl="minikube kubectl --"

# Git-Helfer: shot = add + commit in einem Schritt
unalias shot 2>/dev/null

shot() {
  # Prüfen, ob wir in einem Git-Repository sind
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "❌ Dieses Verzeichnis ist kein Git-Repository."
    echo "   → Du kannst eins erstellen mit: git init"
    return 1
  fi

  # Argumente parsen
  files=()
  message=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -m)
        shift
        message="$1"
        ;;
      *)
        files+=("$1")
        ;;
    esac
    shift
  done

  # Dateien hinzufügen
  if [ ${#files[@]} -eq 0 ]; then
    echo "📂 Keine Dateien angegeben – füge alle hinzu (git add .)"
    git add .
  else
    echo "📂 Füge Dateien hinzu: ${files[*]}"
    git add "${files[@]}"
  fi

  # Commit ausführen
  if [ -z "$message" ]; then
    echo "❌ Keine Commit-Message angegeben! Bitte -m \"Nachricht\" angeben."
    return 1
  fi

  echo "💬 Commit mit Nachricht: \"$message\""
  git commit -m "$message"

  # Optional: Status danach anzeigen
  echo
  git status -sb
}

alias restore="git restore"

checkout() {
  local commit
  commit=$(git log --oneline | fzf --prompt="🔍 Commit auswählen: " --height=80%)
  [ -n "$commit" ] || return
  git checkout $(echo "$commit" | awk '{print $1}')
}

memmap() {
  if [ -z "$1" ]; then
    echo "🔹 Nutzung: memmap <PID>"
    return 1
  fi

  local PID=$1

  if [ ! -r "/proc/$PID/smaps" ]; then
    echo "❌ Prozess $PID existiert nicht oder keine Berechtigung."
    return 1
  fi

  echo "📊 Speicherverteilung für PID $PID"
  echo "--------------------------------------"

  printf "%-20s %12s %10s\n" "Segment" "RSS (MB)" "%"
  echo "--------------------------------------"

  awk '
    /^[0-9a-f]/ {
      # Extract segment name from address line
      if (match($0, /\[heap\]/)) {
        current = "[heap]"
      } else if (match($0, /\[stack\]/)) {
        current = "[stack]"
      } else if (match($0, /\[vdso\]/)) {
        current = "[vdso]"
      } else if (match($0, /\[vvar\]/)) {
        current = "[vvar]"
      } else if (match($0, /\[vsyscall\]/)) {
        current = "[vsyscall]"
      } else if (match($0, /\[vvar_vclock\]/)) {
        current = "[vvar_vclock]"
      } else if (NF > 5 && $NF ~ /\//) {
        # Has a filename/path - group similar files
        path = $NF
        if (path ~ /\.so(\.|$)/) {
          current = "[libraries]"
        } else if (path ~ /\.zwc$/) {
          current = "[zwc-files]"
        } else {
          current = path
        }
      } else {
        # Anonymous mapping
        current = "[anon]"
      }
    }
    /^Rss:/ {
      section_rss[current] += $2
      total_rss += $2
    }
    END {
      for (key in section_rss) {
        rss_mb = section_rss[key] / 1024
        perc = (section_rss[key] / total_rss) * 100
        printf "%-20s %10.2f %9.2f%%\n", key, rss_mb, perc
      }
      
      print "TOTAL:" total_rss > "/dev/stderr"
    }
  ' "/proc/$PID/smaps" 2>&1 | grep -v "^TOTAL:" | sort -t ' ' -k3 -nr

  total=$(awk '/^Rss:/ {total += $2} END {printf "%.2f", total/1024}' "/proc/$PID/smaps")
  
  echo "--------------------------------------"
  echo "Gesamter RSS: $total MB"
}

export mytimezone="Europe/Berlin"

n8n() {
  docker run -it --rm \
 --name n8n \
 -p 5678:5678 \
 -e GENERIC_TIMEZONE=$mytimezone \
 -e TZ=$mytimezone \
 -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
 -e N8N_RUNNERS_ENABLED=true \
 -v n8n_data:/home/node/.n8n \
 docker.n8n.io/n8nio/n8n
}

git_sec() {
  if [ $# -eq 0 ]; then
    echo "Usage: git_sec <filename-pattern> [<filename-pattern> ...]"
    return 1
  fi

  for pattern in "$@"; do
    echo "=== Searching for: $pattern ==="
    git log --all --pretty=format:"%h | %an | %ad | %s" --name-only -- "**/$pattern" | awk 'NF'
    echo
  done
}

license_audit() {
  local target="${1:-.}"
  local outdir="$target/.license_scan"
  mkdir -p "$outdir"

  echo "🔍 [INFO] Starte PARALLELEN Lizenz- und Sicherheits-Scan für: $target"
  echo "------------------------------------------------------------"

  # 1️⃣ Quellcode-Lizenzen
  (
    echo "📄 [1/5] Scanne Quellcode-Lizenzen..."
    docker run --rm -v "$(realpath "$target")":/src ghcr.io/nexb/scancode-toolkit:latest \
      --json-pp /src/.license_scan/scancode.json /src > /dev/null 2>&1
    echo "✅ ScanCode abgeschlossen → $outdir/scancode.json"
  ) &

  # 2️⃣ Abhängigkeitslizenzen
  (
    echo "📦 [2/5] Prüfe Abhängigkeitslizenzen..."
    if [[ -f "$target/package.json" ]]; then
      docker run --rm -v "$(realpath "$target")":/scan licensee/licensee detect /scan --json > "$outdir/dependencies.json" 2>/dev/null
      echo "✅ npm/yarn Dependencies analysiert → $outdir/dependencies.json"
    elif [[ -f "$target/requirements.txt" || -f "$target/pyproject.toml" ]]; then
      docker run --rm -v "$(realpath "$target")":/scan palkan/license_finder report --format json > "$outdir/dependencies.json" 2>/dev/null
      echo "✅ Python Dependencies analysiert → $outdir/dependencies.json"
    else
      echo "ℹ️  Keine Abhängigkeitsdateien gefunden."
    fi
  ) &

  # 3️⃣ Secrets
  (
    echo "🛡️  [3/5] Scanne auf Secrets & sensible Inhalte..."
    docker run --rm -v "$(realpath "$target")":/data ghcr.io/gitguardian/ggshield scan repo /data --json > "$outdir/ggshield.txt" 2>/dev/null
    echo "✅ Secret-Scan abgeschlossen → $outdir/ggshield.txt"
  ) &

  # 4️⃣ SBOM
  (
    echo "🧾 [4/5] Erstelle SBOM (SPDX JSON)..."
    docker run --rm -v "$(realpath "$target")":/src anchore/syft:latest dir:/src -o spdx-json=/src/.license_scan/sbom.json > /dev/null 2>&1
    echo "✅ SBOM erstellt → $outdir/sbom.json"
  ) &

  wait
  echo "⚖️  [5/5] Analysiere Ergebnisse..."
  echo "🖥️  [INFO] Erstelle HTML-Report..."

  # 5️⃣ HTML-Report
  {
    echo "<!DOCTYPE html>"
    echo "<html lang='de'><head><meta charset='UTF-8'>"
    echo "<title>Lizenz- & Sicherheits-Report</title>"
    echo "<style>
      body { font-family: system-ui, sans-serif; background: #f9fafb; color: #111; margin: 2rem; }
      h1 { color: #0369a1; border-bottom: 3px solid #0ea5e9; padding-bottom: .3rem; }
      .section { background: white; box-shadow: 0 2px 6px rgba(0,0,0,0.1); border-radius: 12px; margin: 1.2rem 0; padding: 1rem 1.4rem; }
      .ok { color: #16a34a; font-weight: bold; }
      .warn { color: #d97706; font-weight: bold; }
      .err { color: #dc2626; font-weight: bold; }
      code { background: #f1f5f9; padding: 3px 5px; border-radius: 6px; font-size: 0.9rem; }
      table { border-collapse: collapse; width: 100%; margin-top: .5rem; }
      th, td { padding: .5rem .8rem; border-bottom: 1px solid #e5e7eb; text-align: left; }
      th { background: #f3f4f6; }
    </style></head><body>"
    echo "<h1>🔍 Lizenz- & Sicherheits-Report</h1>"

    echo "<div class='section'><h2>📄 Quellcode-Lizenzen</h2>"
    if [[ -f "$outdir/scancode.json" ]]; then
      echo "<p class='ok'>✅ ScanCode abgeschlossen – Datei gefunden.</p>"
    else
      echo "<p class='err'>❌ Keine ScanCode-Daten gefunden!</p>"
    fi
    echo "</div>"

    echo "<div class='section'><h2>📦 Abhängigkeitslizenzen</h2>"
    if [[ -f "$outdir/dependencies.json" ]]; then
      echo "<p class='ok'>✅ Abhängigkeitslizenzen analysiert.</p>"
    else
      echo "<p class='warn'>⚠️ Keine Abhängigkeitsdaten gefunden oder keine Packages vorhanden.</p>"
    fi
    echo "</div>"

    echo "<div class='section'><h2>🛡️ Secret-Scan</h2>"
    if [[ -f "$outdir/ggshield.txt" ]]; then
      local secrets_found
      secrets_found=$(grep -c '"policy_break_count":[1-9]' "$outdir/ggshield.txt" 2>/dev/null || echo 0)
      secrets_found="${secrets_found//[^0-9]/}"  # nur Ziffern behalten
      if [[ "${secrets_found:-0}" -gt 0 ]] 2>/dev/null; then
        echo "<p class='err'>🚨 Warnung: $secrets_found mögliche Secrets gefunden!</p>"
      else
        echo "<p class='ok'>✅ Keine Secrets gefunden.</p>"
      fi
    else
      echo "<p class='warn'>⚠️ Secret-Scan-Ergebnisse fehlen.</p>"
    fi
    echo "</div>"

    echo "<div class='section'><h2>🧾 SBOM (Software Bill of Materials)</h2>"
    if [[ -f "$outdir/sbom.json" ]]; then
      echo "<p class='ok'>✅ SBOM erstellt – SPDX JSON verfügbar.</p>"
    else
      echo "<p class='err'>❌ SBOM konnte nicht erstellt werden.</p>"
    fi
    echo "</div>"

    echo "<div class='section'><h2>📊 Zusammenfassung</h2>"
    echo "<table><tr><th>Check</th><th>Status</th></tr>"
    echo "<tr><td>Quellcode-Lizenzen</td><td>$( [[ -f "$outdir/scancode.json" ]] && echo ✅ || echo ❌ )</td></tr>"
    echo "<tr><td>Abhängigkeiten</td><td>$( [[ -f "$outdir/dependencies.json" ]] && echo ✅ || echo ⚠️ )</td></tr>"
    echo "<tr><td>Secrets</td><td>$( [[ -f "$outdir/ggshield.txt" ]] && echo ✅ || echo ⚠️ )</td></tr>"
    echo "<tr><td>SBOM</td><td>$( [[ -f "$outdir/sbom.json" ]] && echo ✅ || echo ❌ )</td></tr>"
    echo "</table>"
    echo "<p>📁 Ergebnisse unter: <code>$outdir</code></p>"
    echo "</div>"
    echo "<footer style='text-align:center; color:#6b7280; margin-top:2rem;'>"
    echo "Erstellt am $(date '+%Y-%m-%d %H:%M:%S') auf $(hostname)"
    echo "</footer></body></html>"
  } > "$outdir/report.html"

  echo "✅ HTML-Report erstellt → $outdir/report.html"
  echo "------------------------------------------------------------"
  echo "📊 Vollständige Ergebnisse im Ordner: $outdir"
  echo "------------------------------------------------------------"

  if command -v xdg-open >/dev/null 2>&1; then
    nohup xdg-open "$outdir/report.html" >/dev/null 2>&1 &
  fi
}
