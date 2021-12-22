#!/usr/bin/env bash
# This is designed to be run from within a directory that contains the following files:
# annotations.r
# spek.json
# performance.csv
# templates.json
# causal_pathways.json

COL_WIDTH=30
LOG_FILE=vignette.log

# Define
# Check for dependencies

command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

command -v ruby 1> /dev/null 2>&1 || \
  { echo >&2 "ruby required but it's not installed.  Aborting."; exit 1; }

command -v jq 1> /dev/null 2>&1 || \
  { echo >&2 "jq required but it's not installed.  Aborting."; exit 1; }

# Create outputs directory
mkdir -p outputs

# Create log file
date > ${LOG_FILE}

# Run bitstomach on performance data, spek, and annotations
printf "%-${COL_WIDTH}s" "Running BitStomach..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
$DISPLAY_LAB_HOME/bit-stomach/bin/bitstomach.sh -s spek.json -d performance.csv -a annotations.r 2>> ${LOG_FILE} | jq . > outputs/spek_bs.json
printf "exit status: %d\n" "${?}"

# Run candidate smasher on spek (spek_bs.json) and templates
printf "%-${COL_WIDTH}s" "Running CandidateSmasher..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
$DISPLAY_LAB_HOME/candidate-smasher/bin/cansmash --path=outputs/spek_bs.json --md-source=templates.json 2>> ${LOG_FILE} | jq . > outputs/spek_cs.json
printf "exit status: %d\n" "${?}"

# Run think pudding on spek (spek_cs.json) and causal pathways
printf "%-${COL_WIDTH}s" "Running ThinkPudding..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
$DISPLAY_LAB_HOME/think-pudding/bin/thinkpudding.sh -s outputs/spek_cs.json -p causal_pathways.json 2>> ${LOG_FILE} > outputs/spek_tp.json
printf "exit status: %d\n" "${?}"

printf "Log written to ${LOG_FILE}\n"
