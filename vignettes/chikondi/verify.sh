#!/usr/bin/env bash
# This is designed to be run from within a specific vignette's directory
#   Use verify script as a reminder of what this particular result should be.


EXPECTED_FILE=outputs/spek_tp.json

# Expect spek from think pudding to exist and not be empty.
if [[ -f "${EXPECTED_FILE}" ]]; then
  echo "${EXPECTED_FILE} exists"
else
  echo "${EXPECTED_FILE} missing"
  exit 1
fi

# Use jq as hacky search of output

echo "Expected candidate contents:"
cat << HEREDOC
  "@type" : "http://purl.obolibrary.org/obo/cpo_0000053",
  "AncestorPerformer" : "_:pChikondi",
  "AncestorTemplate" : "http://feedbacktailor.org/ftkb#BetterGoalBar",
  "acceptable_by" : "http://feedbacktailor.org/ftkb#GoalBetter",
HEREDOC

echo -e "\nActual candidate:"

jq '."@graph"[] | select(.AncestorPerformer | . == "_:pChikondi")' "${EXPECTED_FILE}"


# Specific test for expected candidate
RESULT=$(jq '."@graph"[] | 
            select(.AncestorPerformer | . == "_:pChikondi") | 
            select(.acceptable_by | contains("GoalBetter")) // [] | 
            length'\
    "${EXPECTED_FILE}"
)

if [[ ${RESULT} != 0 ]]; then
  echo -e "\n✓ Candidate appears good."
else
  echo -e "\n✗ No candidate appears good."
fi

echo -e "\nExamine ${EXPECTED_FILE} for more details."
