#!/usr/bin/env bash
# This is designed to be run from within a directory that contains the following files:
# annotations.r
# spek.json
# performance.csv
# templates.json
# causal_pathways.json

COL_WIDTH=30
COL_WIDTH=30
LOG_FILE="${PFP_LOG_FILE:=vignette.log}"
KB_DIR="${PFP_KB_DIR:=.}"
DATA_DIR="${PFP_DATA_DIR:=.}"
OUTPUT_DIR="${PFP_OUTPUT_DIR:=outputs}"

# CHeck for data and knowledge base overrides
PARAMS=()
while (( "$#" )); do
  case "$1" in
    -k|--knowledge)
      KB_DIR="${2}"
      shift 2
      ;;
    -d|--data)
      PFP_DATA_DIR="${2}"
      shift 2
      ;;
    -o|--output)
      OUTPUT_DIR="${2}"
      shift 2
      ;;
    -l|--log)
      LOG_FILE="${2}"
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Aborting: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS+=("${1}")
      shift
      ;;
  esac
done


# Define
# Check for dependencies

command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

command -v ruby 1> /dev/null 2>&1 || \
  { echo >&2 "ruby required but it's not installed.  Aborting."; exit 1; }

command -v jq 1> /dev/null 2>&1 || \
  { echo >&2 "jq required but it's not installed.  Aborting."; exit 1; }

# Create ${OUTPUT_DIR} directory
mkdir -p ${OUTPUT_DIR}

# Create log file
date > ${LOG_FILE}

# Run bitstomach on performance data, spek, and annotations
printf "%-${COL_WIDTH}s" "Running BitStomach..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
$DISPLAY_LAB_HOME/bit-stomach/bin/bitstomach.sh -s ${KB_DIR}/spek.json -d ${PFP_DATA_DIR}/performance.csv -a ${KB_DIR}/annotations.r 2>> ${LOG_FILE} | jq . > ${OUTPUT_DIR}/spek_bs.json
printf "exit status: %d\n" "${?}"

# Run candidate smasher on spek (spek_bs.json) and templates
printf "%-${COL_WIDTH}s" "Running CandidateSmasher..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
$DISPLAY_LAB_HOME/candidate-smasher/bin/cansmash --path=${OUTPUT_DIR}/spek_bs.json --md-source=${KB_DIR}/templates.json 2>> ${LOG_FILE} | jq . > ${OUTPUT_DIR}/spek_cs.json
printf "exit status: %d\n" "${?}"

# Run think pudding on spek (spek_cs.json) and causal pathways
printf "%-${COL_WIDTH}s" "Running ThinkPudding..." | tee -a ${LOG_FILE}
printf "\n" >> ${LOG_FILE}
$DISPLAY_LAB_HOME/think-pudding/bin/thinkpudding.sh -s ${OUTPUT_DIR}/spek_cs.json -p ${KB_DIR}/causal_pathways.json 2>> ${LOG_FILE} > ${OUTPUT_DIR}/spek_tp.json
printf "exit status: %d\n" "${?}"

printf "Log written to ${LOG_FILE}\n"
