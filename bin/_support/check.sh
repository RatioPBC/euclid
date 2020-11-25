#!/usr/bin/env sh

source "bin/_support/cecho.sh"

check() {
  description=$1
  command=$2
  remedy=$3

  cecho -n --cyan "[checking] ${description}" --white "... "

  eval "${command} > .doctor.out 2>&1"

  if [ $? -eq 0 ]; then
    cecho --green "OK"
    return 0
  else
    cecho --red "FAILED"
    cat .doctor.out
    echo
    cecho --cyan "Possible remedy: " --yellow "${remedy}"
    cecho --cyan "(it's in the clipboard)"
    echo -n ${remedy} | pbcopy
    exit 1
  fi
}

xcheck() {
  description=$1
  command=$2
  remedy=$3

  cecho -n --yellow "[checking] ${description}" --white "... "
  cecho --yellow "SKIPPED"
  return 0
}
