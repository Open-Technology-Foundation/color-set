#!/bin/bash
#shellcheck disable=SC1091
set -euo pipefail

declare -- BCS_DIR=/ai/scripts/Okusi/bash-coding-standard
source "$BCS_DIR"/bcs

declare -- rulefile
(($#)) || {
  >&2 echo "usage: workflow filename|BCScode"
  exit 1
}

cd "$BCS_DIR"

declare -- rulefile=''
rulefile=$(./bcs decode "$1" 2>/dev/null || true)
if [[ -z $rulefile ]]; then
  >&2 echo "BCS code ${1@Q} does not exist."

  file=${1/BCS}
  file=${file//[a-zA-Z_\.,\/-]}
  #TODO: test that remainder of file is all digits, and in a multiple of 2
  : ...
  ((${#file} % 2 == 0)) || {
    >&2 echo "invalid BCS code ${file@Q}"
    exit 1
  }  
#  yn "Do you wish to create rulefile ${file@Q}?" || exit 1
  
  rulefile=$file
fi

declare -p rulefile
#fin
