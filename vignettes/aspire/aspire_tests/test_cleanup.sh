#!/usr/bin/env bash

# Output column width
COL_WIDTH=20
RES_WIDTH=13
MSG_FORMAT="%-${COL_WIDTH}s ...%-${RES_WIDTH}s %s"

# Check for existence of expected run artifacts
OUT_FILES=(fuseki.out run test_results)

# Shutdown fuseki if running
FUSEKI_PID=$(ps -ef | grep 'java.*fuseki' | grep -v grep | awk '{ print $2 }')
if [[ "$FUSEKI_PID" ]]; then
  kill ${FUSEKI_PID}
fi

# Remove run artifacts if present
for f in "${OUT_FILES[@]}"; do
  if [[ -f "${f}" ]]; then
    rm "${f}"
  elif [[ -d "${f}" ]]; then
    rm -rf "${f}"
  fi
done
