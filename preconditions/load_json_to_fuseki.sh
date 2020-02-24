#!/usr/bin/env bash

# Load a spek into fuseki for interrogation.
# Use 
#  ./load_spek.sh spek.json spek
#  ./load_spek.sh causalpaths.json seeps


INFILE=${1}
GRAPH=${2}

if [[ ${#} -ne 2 ]]; then
  echo "expected two args"
  exit 1
fi

if [[ ! -e ${INFILE} ]]; then
  echo "Infile file not found: ${INFILE}"
  exit 1
fi

if [[ -z $GRAPH ]]; then 
  echo "Graph name not specified: (spek|seeps)"
fi

ping_fuseki(){ curl -s -o /dev/null -w "%{http_code}" localhost:3030/$/ping; }

if [[ $(ping_fuseki) -ne 200 ]]; then
  echo >&2 "Fuseki not running locally. Attempting to start it."; 

  # Try to start custom fuseki locally
  export JVM_ARGS="-Xmx100g -Xms20g"
  fuseki-server --mem --update /ds 1> fuseki.out 2>&1 &

  # Wait for it to start.
  COUNTER=0
  MAX_PINGS=4
  until [[ $(ping_fuseki) -eq 200 || ${COUNTER} -eq ${MAX_PINGS} ]]; do
    read -p "Waiting five secs for Fuseki to start..." -t 5
    echo ""
    let COUNTER=${COUNTER}+1
  done
fi

echo -e >&2 "\nLoading results"; 
curl --silent -X PUT --data-binary @${INFILE} \
  --header 'Content-type: application/ld+json' \
  "http://localhost:3030/ds?graph=${GRAPH}" >&2

