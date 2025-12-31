#!/bin/bash
#shellcheck disable=SC1091,SC2015
# SC1091: Can't follow non-constant source (expected)
# SC2015: A && B || C pattern used correctly for pass/fail reporting
set -euo pipefail

# Test suite for color-set library
declare -i passed=0 failed=0

# Helper function to report test results
test_result() {
  local name=$1
  local result=$2
  if [[ $result == "PASS" ]]; then
    echo "✓ ${name}"
    ((passed+=1))
  else
    echo "✗ ${name}: ${3:-Failed}"
    ((failed+=1))
  fi
}

echo "======================================"
echo "color-set Test Suite"
echo "======================================"
echo

# Test 1: Basic tier sourcing (traditional)
echo "Test 1: Basic tier - traditional syntax"
unset NC RED GREEN YELLOW CYAN BLUE MAGENTA BOLD ITALIC UNDERLINE DIM REVERSE VERBOSE DEBUG DRY_RUN PROMPT 2>/dev/null || :
source ../color-set
color_set basic
[[ -n $NC && -n $RED && -n $GREEN && -n $YELLOW && -n $CYAN ]] && \
  test_result "Basic tier colors set" "PASS" || \
  test_result "Basic tier colors set" "FAIL" "Not all basic colors defined"
[[ -z ${BLUE:-} && -z ${MAGENTA:-} ]] && \
  test_result "Complete tier colors not set" "PASS" || \
  test_result "Complete tier colors not set" "FAIL" "Complete colors should not be set"
echo

# Test 2: Complete tier sourcing (enhanced syntax)
echo "Test 2: Complete tier - enhanced syntax"
unset NC RED GREEN YELLOW CYAN BLUE MAGENTA BOLD ITALIC UNDERLINE DIM REVERSE VERBOSE DEBUG DRY_RUN PROMPT 2>/dev/null || :
source ../color-set complete
[[ -n $NC && -n $RED && -n $GREEN && -n $YELLOW && -n $CYAN && \
   -n $BLUE && -n $MAGENTA && -n $BOLD && -n $ITALIC && \
   -n $UNDERLINE && -n $DIM && -n $REVERSE ]] && \
  test_result "Complete tier colors set" "PASS" || \
  test_result "Complete tier colors set" "FAIL" "Not all complete colors defined"
echo

# Test 3: FLAGS with basic tier
echo "Test 3: FLAGS with basic tier"
unset NC RED GREEN YELLOW CYAN BLUE MAGENTA BOLD ITALIC UNDERLINE DIM REVERSE VERBOSE DEBUG DRY_RUN PROMPT 2>/dev/null || :
source ../color-set basic flags
[[ -n ${VERBOSE:-} ]] && \
  test_result "VERBOSE set with basic flags" "PASS" || \
  test_result "VERBOSE set with basic flags" "FAIL" "VERBOSE should be set"
[[ -z ${DEBUG:-} && -z ${DRY_RUN:-} && -z ${PROMPT:-} ]] && \
  test_result "DEBUG/DRY_RUN/PROMPT not set with basic flags" "PASS" || \
  test_result "DEBUG/DRY_RUN/PROMPT not set with basic flags" "FAIL" "Should only set VERBOSE"
echo

# Test 4: FLAGS with complete tier
echo "Test 4: FLAGS with complete tier"
unset NC RED GREEN YELLOW CYAN BLUE MAGENTA BOLD ITALIC UNDERLINE DIM REVERSE VERBOSE DEBUG DRY_RUN PROMPT 2>/dev/null || :
source ../color-set complete flags
[[ -n ${VERBOSE:-} && -n ${DEBUG:-} && -n ${DRY_RUN:-} && -n ${PROMPT:-} ]] && \
  test_result "All FLAGS set with complete flags" "PASS" || \
  test_result "All FLAGS set with complete flags" "FAIL" "All four variables should be set"
echo

# Test 5: Never mode (colors disabled)
echo "Test 5: Never mode - colors disabled"
source ../color-set never complete
[[ $NC == "" && $RED == "" && $GREEN == "" ]] && \
  test_result "Colors disabled with never" "PASS" || \
  test_result "Colors disabled with never" "FAIL" "Colors should be empty strings"
echo

# Test 6: Always mode (colors forced on)
echo "Test 6: Always mode - colors forced on"
source ../color-set always complete
[[ -n $NC && $NC =~ $'\033' ]] && \
  test_result "Colors enabled with always" "PASS" || \
  test_result "Colors enabled with always" "FAIL" "Colors should contain ANSI codes"
echo

# Test 7: Color output test
echo "Test 7: Visual color test"
source ../color-set complete always
echo "  ${RED}RED${NC} ${GREEN}GREEN${NC} ${YELLOW}YELLOW${NC} ${CYAN}CYAN${NC}"
echo "  ${BLUE}BLUE${NC} ${MAGENTA}MAGENTA${NC}"
echo "  ${BOLD}BOLD${NC} ${ITALIC}ITALIC${NC} ${UNDERLINE}UNDERLINE${NC} ${DIM}DIM${NC} ${REVERSE}REVERSE${NC}"
test_result "Visual output" "PASS"
echo

# Test 8: Combined attributes
echo "Test 8: Combined attributes"
source ../color-set complete always
echo "  ${BOLD}${RED}Bold Red${NC}"
echo "  ${ITALIC}${BLUE}Italic Blue${NC}"
echo "  ${UNDERLINE}${GREEN}Underline Green${NC}"
echo "  ${BOLD}${UNDERLINE}${YELLOW}Bold Underline Yellow${NC}"
test_result "Combined attributes" "PASS"
echo

# Summary
echo "======================================"
echo "Test Results:"
echo "  Passed: ${passed}"
echo "  Failed: ${failed}"
echo "  Total:  $((passed + failed))"
echo "======================================"

((failed == 0)) && exit 0 || exit 1
#fin
