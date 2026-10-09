#!/usr/bin/env bash
#
# NOTE TO FUTURE CLAUDE / EDITORS:
# On fleet machines this and ~/.claude/settings.json are read-only symlinks
# managed by home-manager. Editing them in place will fail or be overwritten.
# To change Claude Code config, edit fleet/roy/home.nix
# (programs.claude-code.settings) and this file at fleet/common/claude-statusline.sh,
# then run `nh os switch ~/src/fleet#roy`.
#
# Claude Code statusLine — mirrors the user's Starship prompt
# (bold-cyan truncated dir + bold-purple git branch), then dimmed model and
# context-window / usage-limit info:
#
#   ~/src/schedule-builder |  main | Opus 4.8 | ctx: 14% | (3:27) 12% (4:23:17) 8%
#                                                          \         \
#                                               5h limit (reset) used  7d limit (reset) used

input=$(cat)

# Shared styling: dim ` | ` separator between every piece of info.
dim=$'\033[2m'; rst=$'\033[0m'
sep=" ${dim}|${rst} "

dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
model=$(jq -r '.model.display_name // empty' <<<"$input")
[ -z "$dir" ] && dir="$PWD"

# Directory (bold cyan): ~ for $HOME, truncated to the last 3 path components.
disp=${dir/#$HOME/\~}
IFS='/' read -ra parts <<<"$disp"
n=${#parts[@]}
if [ "$n" -gt 3 ]; then
  disp="…/${parts[n-3]}/${parts[n-2]}/${parts[n-1]}"
fi
out=$'\033[1;36m'"$disp"$'\033[0m'

# Git branch (bold purple), only inside a repo.
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -n "$branch" ] && out+="${sep}"$'\033[1;35m'" $branch"$'\033[0m'

# Model (dim).
[ -n "$model" ] && out+="${sep}${dim}${model}${rst}"

# --- context window % + rate-limit usage -------------------------------------
# Colors: ctx yellow, limits blue; any percentage over 85% turns red.
now=$(date +%s)
yel=$'\033[33m'; blu=$'\033[34m'; red=$'\033[31m'
usage=""

# Color for a percentage: red when over 85%, else the given base color.
pctcol() { if [ "$1" -gt 85 ]; then printf '%s' "$red"; else printf '%s' "$2"; fi; }

# Format seconds-until-reset; $2 = "hm" -> h:mm, "dhm" -> d:hh:mm.
countdown() {
  local s=$1 fmt=$2
  ((s < 0)) && s=0
  if [ "$fmt" = dhm ]; then
    printf '%d:%02d:%02d' $((s/86400)) $(((s%86400)/3600)) $(((s%3600)/60))
  else
    printf '%d:%02d' $((s/3600)) $(((s%3600)/60))
  fi
}

ctx=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
[ -n "$ctx" ] && usage="${yel}ctx: $(pctcol "$ctx" "$yel")${ctx}%${rst}"

read -r p5 r5 < <(jq -r '.rate_limits.five_hour | "\(.used_percentage // "") \(.resets_at // "")"' <<<"$input")
[ -n "$p5" ] && usage+="${sep}${blu}($(countdown $((r5 - now)) hm))${rst} $(pctcol "$p5" "$blu")${p5}%${rst}"

read -r p7 r7 < <(jq -r '.rate_limits.seven_day | "\(.used_percentage // "") \(.resets_at // "")"' <<<"$input")
[ -n "$p7" ] && usage+=" ${blu}($(countdown $((r7 - now)) dhm))${rst} $(pctcol "$p7" "$blu")${p7}%${rst}"

[ -n "$usage" ] && out+="${sep}${usage}"

printf '%s' "$out"
