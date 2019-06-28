#!/usr/bin/env bash

# Check and Start FUSEKI running.
FUSEKI_DIR=/opt/fuseki/apache-jena-fuseki-3.10.0

ping_fuseki(){ curl -s -o /dev/null -w "%{http_code}" localhost:3030/$/ping; }

if [[ $(ping_fuseki) -ne 200 ]]; then
  echo >&2 "Fuseki not running locally. Attempting to start it."; 

  # Try to start custom fuseki locally
  ${FUSEKI_DIR}/fuseki-server --mem --update /ds 1> fuseki.out 2>&1 &

  # Wait for it to start.
  COUNTER=0
  MAX_PINGS=4
  until [[ $(ping_fuseki) -eq 200 || ${COUNTER} -eq ${MAX_PINGS} ]]; do
    read -p "Waiting five secs for Fuseki to start..." -t 5
    echo ""
    let COUNTER=${COUNTER}+1
  done
fi

# Run bitstomach and candidates smasher to get candidates
bitstomach.sh\
  -a example/k01ex-annotations.r \
  -s example/k01ex-spek.json \
  -d example/k01ex-data.csv |\
cansmash --md-source=example/k01ex-templates-md.json |\
jq . > /tmp/k01-cans.json

# Run think pudding determine acceptable candidates
cat /tmp/k01-cans.json |\
thinkpudding.sh -p example/k01ex-causal-paths.json > /tmp/k01-think.json

# Use following line to emit candidates only
#cat /tmp/k01-think.json | jq '."@graph"[] | select( ."@type" == "http://example.com/cpo#cpo_0000053")'

# Emit entire spek
cat /tmp/k01-think.json
