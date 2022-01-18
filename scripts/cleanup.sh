#!/usr/bin/env bash
# This is designed to be run from within a vignette directory

# Output column width
COL_WIDTH=20
RES_WIDTH=13
MSG_FORMAT="%-${COL_WIDTH}s ...%-${RES_WIDTH}s %s"

# Check for existence of expected run artifacts
OUT_FILES=( fuseki.out run outputs )

# Shutdown fuseki if running
FUSEKI_PID=$(ps -ef | grep 'java.*fuseki' | grep -v grep | awk '{ print $2 }')
if [[ -z "$FUSEKI_PID" ]]; then
  RES="not running"
  ACT="skipping"
else
  RES="running"
  if kill ${FUSEKI_PID}; then
    ACT="killed process"
  else
    ACT="proc not killed"
  fi
fi
MSG=$(printf "${MSG_FORMAT}" "fuseki-server" "${RES}." "${ACT}")
echo "${MSG}"

# Remove run artifacts if present
for f in "${OUT_FILES[@]}"; do
  
  if [[ -f "${f}" ]]; then
    RES="exists"
    ACT="deleting file"
    rm "${f}"
  elif [[ -d "${f}" ]]; then
    RES="exists"
    ACT="deleting dir"
    rm -rf "${f}"
  else
    RES="not found"
    ACT="skipping"
  fi
  MSG=$(printf "${MSG_FORMAT}" "${f}" "${RES}." "${ACT}")
  echo "${MSG}"
done
