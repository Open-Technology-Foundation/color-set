#!/bin/bash
# Set global colors for NC RED GREEN YELLOW CYAN BLUE MAGENTA BOLD ITALIC UNDERLINE DIM REVERSE

color_set() {
  local -i color=-1 complete=0 verbose=0 flags=0
  while (($#)); do
    case ${1:-auto} in
      complete) complete=1 ;;
      basic)    complete=0 ;;

      flags)    flags=1 ;;

      verbose|-v|--verbose)
                verbose=1 ;;

      always)   color=1 ;;
      never|none)
                color=0 ;;
      auto)     color=-1 ;;

      *)        >&2 echo "$FUNCNAME: error: Invalid color mode ${1@Q}. Use 'auto', 'always', or 'never'."
                return 1 ;;
    esac
    shift
  done
  ((color == -1)) && { [[ -t 1 && -t 2 ]] && color=1 || color=0; }

  if ((flags)); then
    declare -ig VERBOSE=${VERBOSE:-1}
    ((complete)) && declare -ig DEBUG=0 DRY_RUN=1 PROMPT=1 || :
  fi

  if ((color)); then
    declare -g NC=$'\033[0m' RED=$'\033[0;31m' GREEN=$'\033[0;32m' YELLOW=$'\033[0;33m' CYAN=$'\033[0;36m'
    ((complete)) && declare -g BLUE=$'\033[0;34m' MAGENTA=$'\033[0;35m' BOLD=$'\033[1m' ITALIC=$'\033[3m' UNDERLINE=$'\033[4m' DIM=$'\033[2m' REVERSE=$'\033[7m' || :
  else
    declare -g NC='' RED='' GREEN='' YELLOW='' CYAN=''
    ((complete)) && declare -g BLUE='' MAGENTA='' BOLD='' ITALIC='' UNDERLINE='' DIM='' REVERSE='' || :
  fi

  if ((verbose)); then
    ((flags)) && declare -p VERBOSE || :
    declare -p NC RED GREEN YELLOW CYAN
    ((complete)) && {
      ((flags)) && declare -p DEBUG DRY_RUN PROMPT || :
      declare -p BLUE MAGENTA BOLD ITALIC UNDERLINE DIM REVERSE
    } || :
  fi

  return 0
}
declare -fx color_set

[[ ${BASH_SOURCE[0]} == "$0" ]] || return 0
#!/bin/bash #semantic
set -euo pipefail

# Handle help requests
if [[ ${1:-} =~ ^(-h|--help|help)$ ]]; then
  cat <<'HELP'
Usage: color-set.sh [OPTIONS...]

Dual-purpose bash library for terminal color management with ANSI escape codes.

MODES:
  Source as library:  source color-set.sh; color_set [OPTIONS]
  Execute directly:   ./color-set.sh [OPTIONS]

OPTIONS:
  complete          Enable complete color set (12 variables)
  basic             Enable basic color set (5 variables) [default]

  always            Force colors on
  never, none       Force colors off
  auto              Auto-detect TTY [default]

  verbose, -v       Print variable declarations
  --verbose

  flags             Set standard BCS globals (VERBOSE, DEBUG, DRY_RUN, PROMPT)
                    Used by _msg system messaging constructs

BASIC TIER (5 variables):
  NC, RED, GREEN, YELLOW, CYAN

COMPLETE TIER (+7 additional variables):
  BLUE, MAGENTA, BOLD, ITALIC, UNDERLINE, DIM, REVERSE

EXAMPLES:
  ./color-set.sh complete verbose
  ./color-set.sh always
  source color-set.sh && color_set complete && echo "${RED}Error${NC}"

OPTIONS can be combined in any order.
HELP
  exit 0
fi

color_set "$@"


#fin
