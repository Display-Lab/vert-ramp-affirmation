#!/usr/bin/env bash
# This is designed to be run from within a vignette directory

# Output column width
COL_WIDTH=20

read -r -d '' RDFCHECK << HEREDOC
require 'rdf';
require 'json/ld';

RDF::Graph.load(ARGV[0])
HEREDOC

# Check for existence of required files
REQ_FILES=( spek.json performance.csv annotations.r templates.json )

for f in "${REQ_FILES[@]}"; do
  if ([[ -f ${f} ]]); then
    RES="exists"
  else
    RES="missing"
  fi
  MSG=$(printf "%-${COL_WIDTH}s ...%s." "${f}", "${RES}")
  echo "${MSG}"
done

# Check json well formed
JSONLD_FILES=( spek.json templates.json )
for f in "${JSONLD_FILES[@]}"; do
  # Check json syntax of spek
  jq 'empty' ${f}
  if [[ $? == 0 ]]; then
    RES='passed'
  else
    RES='failed'
  fi
  MSG=$(printf "%-${COL_WIDTH}s ...jq %s." "${f}" ${RES})
  echo "${MSG}"
done

# Check json-ld parseable
for f in "${JSONLD_FILES[@]}"; do
  # Check json syntax of spek
  ruby -e "${RDFCHECK}" "${f}" 2> /dev/null
  if [[ $? == 0 ]]; then
    RES='passed'
  else
    RES='failed'
  fi
  MSG=$(printf "%-${COL_WIDTH}s ...rdf %s." "${f}" ${RES})
  echo "${MSG}"
done

# Check csv format
OUTPUT=$(frictionless validate performance.csv)
if [[ $? == 0 ]]; then
  RES='passed'
else
  RES='failed'
  echo "${OUTPUT}"
fi

MSG=$(printf "%-${COL_WIDTH}s ...frictionless %s." "performance.csv" ${RES})
echo "${MSG}"

