#!/usr/bin/env bash
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


ANNO_PATH='/home/grosscol/workspace/spekex/inst/extdata/aspire-annotations.r'
DATA_PATH='/home/grosscol/workspace/spekex/inst/extdata/aspire-data.csv'
SPEK_PATH='/home/grosscol/workspace/spekex/inst/extdata/aspire-spek.json'
BS_SPEK=/tmp/bs.json

if [[ ! -e ${BS_SPEK} ]]; then
  bitstomach.sh -s ${SPEK_PATH} -a ${ANNO_PATH} -d ${DATA_PATH} > ${BS_SPEK}
fi

TP_SPEK=/tmp/tp.json
if [[ ! -e ${TP_SPEK} ]]; then
  cansmash generate --path ${BS_SPEK} > ${TP_SPEK}
fi

CP_DIR=/home/grosscol/workspace/kb/causal_pathways
CP_JSON=/tmp/cp.json

if [[ ! -e ${CP_JSON} ]]; then
  jq -s '{ "@context": ([ .[]."@context" ] | unique | .[0]), "@graph":[ .[]."@graph"[] ]}' \
    ${CP_DIR}/*.json > ${CP_JSON}
fi

# Load candidate smasher emitted spek into graph 
curl --silent -X PUT --data-binary "@${TP_SPEK}" \
  --header 'Content-type: application/ld+json' \
  'http://localhost:3030/ds?graph=spek' >&2
 
# Load in causal pathways
curl --silent -X PUT --data-binary @${CP_FILE} \
  --header 'Content-type: application/ld+json' \
  'http://localhost:3030/ds?graph=seeps' >&2

