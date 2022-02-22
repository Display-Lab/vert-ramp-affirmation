#!/usr/bin/env bash

# Usage message
read -r -d '' USE_MSG <<'HEREDOC'
Usage:
  summarize_graph.sh -h
  summarize_graph.sh -s spek.json

summarize_graph reads a spek from stdin or provided file path.
Inserts spek into fuseki, which must be running at localhost:3030

Options:
  -h | --help     print help and exit
  -s | --spek     path to spek file (default to stdin)
HEREDOC

# Parse args
PARAMS=()
while (("$#")); do
  case "$1" in
  -h | --help)
    echo "${USE_MSG}"
    exit 0
    ;;
  -s | --spek)
    SPEK_FILE="${2}"
    shift 2
    ;;
  --) # end argument parsing
    shift
    break
    ;;
  -* | --*=) # unsupported flags
    echo "Aborting: Unsupported flag $1" >&2
    exit 1
    ;;
  *) # preserve positional arguments
    PARAMS+=("${1}")
    shift
    ;;
  esac
done

FUSEKI_DATASET_URL="http://localhost:3030/ds"
GRAPH_NAME="spek"

# Load in spek if supplied
if [ ! -z "${SPEK_FILE}" ]; then
  GRAPH_NAME="temp"
  echo "Using Spek file: " ${SPEK_FILE}
  curl --silent PUT \
    --data-binary "@${SPEK_FILE}" \
    --header 'Content-type: application/ld+json' \
    "${FUSEKI_DATASET_URL}?graph=${FUSEKI_DATASET_URL}/${GRAPH_NAME}" >&2
fi

# SPARQL Queries
# (Putting quotes around the sentinel (USPARQL)
# prevents the text from undergoing parameter expansion (like $GRAPH_NAME))
read -r -d '' PERFORMER_COUNT <<USPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
SELECT (COUNT (DISTINCT ?performer) AS ?numberOfPerformers)
FROM <http://localhost:3030/ds/$GRAPH_NAME>
WHERE {
  ?performer a obo:psdo_0000085
}
USPARQL

read -r -d '' CANDIDATE_COUNT <<USPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
SELECT (COUNT (DISTINCT ?candidate) AS ?numberOfCandidates)
FROM <http://localhost:3030/ds/$GRAPH_NAME>
WHERE {
  ?candidate a obo:cpo_0000053
}
USPARQL

read -r -d '' ACCEPTABLE_CANDIDATE_COUNT <<USPARQL
PREFIX slowmo: <http://example.com/slowmo#>
PREFIX obo: <http://purl.obolibrary.org/obo/>

SELECT (COUNT (DISTINCT ?candidate) AS ?numberOfAcceptableCandidates)
FROM <http://localhost:3030/ds/$GRAPH_NAME>
WHERE {
  ?candidate a obo:cpo_0000053 ;
    slowmo:acceptable_by ?o .
}
USPARQL

read -r -d '' PROMOTED_CANDIDATE_COUNT <<USPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT (DISTINCT ?candidate) AS ?numberOfPromotedCandidates)
FROM <http://localhost:3030/ds/$GRAPH_NAME>
WHERE {
  ?candidate a obo:cpo_0000053 ;
    slowmo:promoted_by ?o .
}
USPARQL

read -r -d '' ANCESTOR_PERFORMER_COUNT <<USPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT(DISTINCT (?ancestorPerformer)) as ?numberOfAncestorPerformers)
FROM <http://localhost:3030/ds/$GRAPH_NAME>
WHERE {
  ?candidate a obo:cpo_0000053 ;
    slowmo:AncestorPerformer ?ancestorPerformer .
}
USPARQL

# *********************************************************************************
# Fail if Fuseki is not running
FUSEKI_PING=$(curl -s -o /dev/null -w "%{http_code}" localhost:3030/$/ping)
if [[ -z ${FUSEKI_PING}} || ${FUSEKI_PING} -ne 200 ]]; then
  # Error
  echo >&2 "Fuseki not running locally."
  exit 1
fi

# SPARQL Time

echo "********** SPEK SUMMARY **********"
echo -n "Number of Performers: "
curl --silent POST \
  --data-binary "${PERFORMER_COUNT}" \
  --header 'Content-type: application/sparql-query' \
  "${FUSEKI_DATASET_URL}/query" | jq '.results.bindings[0].numberOfPerformers.value' >&2

echo -n "Number of Candidates: "
curl --silent POST \
  --data-binary "${CANDIDATE_COUNT}" \
  --header 'Content-type: application/sparql-query' \
  "${FUSEKI_DATASET_URL}/query" | jq '.results.bindings[0].numberOfCandidates.value' >&2

echo -n "Number of Acceptable Candidates: "
curl --silent POST \
  --data-binary "${ACCEPTABLE_CANDIDATE_COUNT}" \
  --header 'Content-type: application/sparql-query' \
  "${FUSEKI_DATASET_URL}/query" | jq '.results.bindings[0].numberOfAcceptableCandidates.value' >&2

echo -n "Number of Promoted Candidates: "
curl --silent POST \
  --data-binary "${PROMOTED_CANDIDATE_COUNT}" \
  --header 'Content-type: application/sparql-query' \
  "${FUSEKI_DATASET_URL}/query" | jq '.results.bindings[0].numberOfPromotedCandidates.value' >&2

echo -n "Number of Ancestor Performers: "
curl --silent POST \
  --data-binary "${ANCESTOR_PERFORMER_COUNT}" \
  --header 'Content-type: application/sparql-query' \
  "${FUSEKI_DATASET_URL}/query" | jq '.results.bindings[0].numberOfAncestorPerformers.value' >&2

if [ ! -z "${SPEK_FILE}" ]; then
  curl --silent --location --request DELETE \
    "${FUSEKI_DATASET_URL}?graph=${FUSEKI_DATASET_URL}/${GRAPH_NAME}"
fi
