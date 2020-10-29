#!/usr/bin/env bash
# This is designed to be run from within a vignette directory

# Output column width
COL_WIDTH=20

# Check for existence of expected run artifacts
OUT_FILES=( fuseki.out run outputs vignette.log )

# Shutdown fuseki if running
# TODO

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
  MSG=$(printf "%-${COL_WIDTH}s ...%-10s %s" "${f}" "${RES}." "${ACT}")
  echo "${MSG}"
done
