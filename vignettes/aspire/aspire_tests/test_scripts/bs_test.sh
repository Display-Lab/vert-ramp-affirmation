#!/usr/bin/env bash
COL_WIDTH=30
COL_WIDTH=30
KNOWLEDGE_BASE_DIR="${DISPLAY_LAB_HOME}/vert-ramp-affirmation/vignettes/aspire"
TEST_DIR="${KNOWLEDGE_BASE_DIR}/aspire_tests"
TEST_DATA_DIR="${TEST_DIR}/data"
OUTPUT_DIR=test_results
LOG_FILE=test_log.txt
VR_SCRIPTS_DIR="${DISPLAY_LAB_HOME}/vert-ramp-affirmation/scripts"

# Check if FUSEKI is running.
FUSEKI_PING=$(curl -s -o /dev/null -w "%{http_code}" localhost:3030/$/ping)
if [[ -z ${FUSEKI_PING}} || ${FUSEKI_PING} -ne 200 ]]; then
  # Error
  echo >&2 "Fuseki not running locally."

  # Try to start custom fuseki locally, will temporarily create a run/ directory
  ${FUSEKI_HOME}/fuseki-server --mem --update /ds 1>fuseki.out 2>&1 &
  read -p "Waiting 5 seconds for Fuseki to start..." -t 5
fi

# Create ${OUTPUT_DIR} directory
mkdir -p ${OUTPUT_DIR}

# Create log file
date >${LOG_FILE}

#run bitstomach on each csv file in the TEST_DATA_DIR directory, and output speks / logs
for file in ${TEST_DATA_DIR}/*.csv;
  do
    test_name=$(basename "${file}" .csv)
    printf "%-${COL_WIDTH}s" "BitStomach - Aspire - ${test_name}" | tee -a ${LOG_FILE}
    printf "\n" >>${LOG_FILE}
    $DISPLAY_LAB_HOME/bit-stomach/bin/bitstomach.sh \
      -s ${KNOWLEDGE_BASE_DIR}/spek.json \
      -d ${file} \
      -a ${KNOWLEDGE_BASE_DIR}/annotations.r \
      2>>${LOG_FILE} | jq . \
      > ${OUTPUT_DIR}/${test_name}.spek.json
    printf "\nexit status: %d\n" "${?}"

    $VR_SCRIPTS_DIR/summarize_graph.sh \
      -s ${OUTPUT_DIR}/${test_name}.spek.json
      2>>${LOG_FILE} | jq . \
      > ${OUTPUT_DIR}/${test_name}.summary.txt
  done



printf "Log written to ${LOG_FILE}\n"
