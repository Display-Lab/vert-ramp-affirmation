#!/usr/bin/env bash

# Check for dependencies 

command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

command -v ruby 1> /dev/null 2>&1 || \
  { echo >&2 "ruby required but it's not installed.  Aborting."; exit 1; }

command -v jq 1> /dev/null 2>&1 || \
  { echo >&2 "jq required but it's not installed.  Aborting."; exit 1; }

# Define locations of pipeline component projects

## Bitstomach
BS=~/workspace/bitstomach
## Candidate Smasher
CS=~/workspace/candidate-smasher
## Think Pudding
TP=~/workspace/think-pudding

# Run Pipeline

IDIR=${BS}/inst/example/causal_pathways

echo -e "\nPIPELINE:\n" >> /dev/stderr

${BS}/bin/bitstomach.sh -a $IDIR/annotations.r -s $IDIR/spek.json -d $IDIR/performer-data.csv |\
  tee /tmp/bs.json |\
  ${CS}/bin/cansmash --md-source=${CS}/spec/fixtures/templates-cp.json |\
  tee /tmp/cs.json |\
  ${TP}/bin/tp.sh -p ${TP}/example/causal_pathways_list.json |\
  tee /tmp/tp.out

