#!/usr/bin/env bash

# Define 
# Check for dependencies 

command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

command -v ruby 1> /dev/null 2>&1 || \
  { echo >&2 "ruby required but it's not installed.  Aborting."; exit 1; }

command -v jq 1> /dev/null 2>&1 || \
  { echo >&2 "jq required but it's not installed.  Aborting."; exit 1; }

# Define locations of pipeline component projects


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

# Die if Fuseki not running.
if [[ $(ping_fuseki) -ne 200 ]]; then
  echo >&2 "Fuseki still not runnig. Exiting."; 
  exit 1
fi

# Run Pipeline

## Bitstomach
BS=~/workspace/bitstomach
## Candidate Smasher
CS=~/workspace/candidate-smasher
## Think Pudding
TP=~/workspace/think-pudding
## Esteemer
ES=~/workspace/esteemer


echo -e "\nPIPELINE:\n" >> /dev/stderr

${BS}/bin/bitstomach.sh -a example/annotations.r -s example/spek.json -d example/performer-data.csv |\
  tee /tmp/bs.json |\
  ${CS}/bin/cansmash --md-source=example/templates-cp.json |\
  tee /tmp/cs.json |\
  ${TP}/bin/tp.sh -p example/causal_pathways_list.json |\
  tee /tmp/tp.json |\
  ${ES}/bin/esteemer.sh |\
  tee /tmp/es.json

