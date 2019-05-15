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

# Run Pipeline for all examples sets
# All CLI's are required to be on PATH

echo -e "\nPIPELINE:\n" >> /dev/stderr

echo -e "\nSham Example:\n" >> /dev/stderr

# Run pipeline for sham example
bitstomach.sh -a example/sham-annotations.r -s example/sham-spek.json -d example/sham-data.csv |\
  tee /tmp/bs.json |\
  cansmash --md-source=example/sham-templates-md.json |\
  tee /tmp/cs.json |\
  thinkpudding.sh -p example/sham-causal-paths.json |\
  tee /tmp/tp.json |\
  esteemer.sh |\
  tee /tmp/es.json

echo -e "\nVA Example:\n" >> /dev/stderr

# Run pipeline for va example
bitstomach.sh -a example/va-annotations.r -s example/va-spek.json -d example/va-data.csv |\
  cansmash --md-source=example/sham-templates-md.json |\
  thinkpudding.sh -p example/va-causal-paths.json |\
  esteemer.sh > /tmp/es-va.json

echo -e "\nMtx Example:\n" >> /dev/stderr

# Run pipeline for mtx example
bitstomach.sh -a example/mtx-annotations.r -s example/mtx-spek.json -d example/mtx-data.csv |\
  cansmash --md-source=example/sham-templates-md.json |\
  thinkpudding.sh -p example/mtx-causal-paths.json |\
  esteemer.sh > /tmp/es-mtx.json
