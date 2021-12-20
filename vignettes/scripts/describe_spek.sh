#!/usr/bin/env bash

# Unless specified as first argument, assume spek.json
SPEK_PATH=${1:-spek.json}

# How many performers?

export PERF_IRI=
echo "Describing ${SPEK_PATH}"

echo -n "Number of performers: "
jq --arg perf_iri "http://example.com/slowmo#IsAboutPerformer" \
  '.[$perf_iri] | length' $SPEK_PATH

#  "http://example.com/slowmo#IsAboutPerformer": [
