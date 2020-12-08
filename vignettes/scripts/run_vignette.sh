#!/usr/bin/env bash
# This is designed to be run from within a vignette directory
# Assumes bitstomach.sh, cansmash, fuseki-server, and thinkpudding.sh are on PATH.

COL_WIDTH=30
LOG_FILE=vignette.log

# Create outputs directory
mkdir -p outputs

# Create log file
date > ${LOG_FILE}

# Run bitstomach on performance data, spek, and annotations
printf "%-${COL_WIDTH}s" "Running BitStomach..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
bitstomach.sh -s spek.json -d performance.csv -a annotations.r 2>> ${LOG_FILE} | jq . > outputs/spek_bs.json
printf "exit status: %d\n" "${?}"

# Run candidate smasher on spek (spek_bs.json) and templates
printf "%-${COL_WIDTH}s" "Running CandidateSmasher..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
cansmash --path=outputs/spek_bs.json --md-source=templates.json 2>> ${LOG_FILE} | jq . > outputs/spek_cs.json
printf "exit status: %d\n" "${?}"

# Run think pudding on spek (spek_cs.json) and causal pathways
printf "%-${COL_WIDTH}s" "Running ThinkPudding..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
thinkpudding.sh -s outputs/spek_cs.json -p causal_pathways.json 2>> ${LOG_FILE} > outputs/spek_tp.json
printf "exit status: %d\n" "${?}"

printf "Log written to ${LOG_FILE}\n"
