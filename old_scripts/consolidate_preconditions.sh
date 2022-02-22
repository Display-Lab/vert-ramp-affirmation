#!/usr/bin/env bash

CP_DIR=/home/grosscol/workspace/kb/causal_pathways
CP_JSON=/tmp/cp.json

# Consolidating causal pathways into a single file if not done already.
if [[ ! -e ${CP_JSON} ]]; then
  jq -s '{ "@context": ([ .[]."@context" ] | unique | .[0]), "@graph":[ .[]."@graph"[] ]}' \
    ${CP_DIR}/*.json > ${CP_JSON}
fi
