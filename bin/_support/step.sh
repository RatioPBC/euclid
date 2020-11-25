#!/usr/bin/env bash

source "bin/_support/cecho.sh"

step() {
  description=$1
  command=$2

  cecho --green "\n▸" --cyan "${description}:" --yellow "${YELLOW}${command}"

  eval "${command}"

  if [ $? -eq 0 ]; then
    cecho --green "OK"
  else
    cecho --red "FAILED"
    exit
  fi
}

section() {
  title=$1
  cecho --yellow "\n${title}"
}

xstep() {
  description=$1
  command=$2

  cecho -n --green "\n▸" --cyan "${description}:" --yellow "${YELLOW}${command}" --white "... "
  cecho --yellow "[SKIPPED]"
  return 0
}
