#!/usr/bin/env bash

# Querries spek graph and produces summary csv
#   Expects s-query to be on PATH
#   Expects thinkpudding.sh to be on PATH

# Count Candidates
read -r -d '' QCANDI <<'QCANDI'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT(?candi) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi a obo:cpo_0000053 .
}
QCANDI

# Count accepted candidates
read -r -d '' ACCEPTED <<'ACCEPTED'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT(?candi) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:acceptable_by ?path .
  ?candi a obo:cpo_0000053 .
}
ACCEPTED

# Count ancestor performers
read -r -d '' ANCEST <<'ANCEST'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT(DISTINCT(?perf)) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:AncestorPerformer ?perf .
  ?candi a obo:cpo_0000053 .
}
ANCEST

# Count ancestor performers of accepted candidates
read -r -d '' ACCANDI <<'ACCANDI'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT(DISTINCT(?perf)) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:AncestorPerformer ?perf .
  ?candi slowmo:acceptable_by ?path .
  ?candi a obo:cpo_0000053 .
}
ACCANDI

# Count candidates accepted by each causal pathway
read -r -d '' CPATHS <<'CPATHS'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT ?path (COUNT(?candi) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:acceptable_by ?path .
  ?candi a obo:cpo_0000053 .
}
GROUP BY ?path
CPATHS

# Count performers accepted by each causal pathways accepts
read -r -d '' PERFPATHS <<'PERFPATHS'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT ?path (COUNT(DISTINCT(?perf)) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:acceptable_by ?path .
  ?candi slowmo:AncestorPerformer ?perf .
}
GROUP BY ?path
PERFPATHS

# Count number of times each annotation occurs in performers
read -r -d '' ANNOS <<'ANNOS'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT ?dtype (COUNT(?dtype) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi obo:RO_0000091 ?disp .
  ?disp a ?dtype .
  ?candi a obo:cpo_0000053 .
}
GROUP BY ?dtype
ANNOS

# Min, Max, Ave number of acceptable candidates per performer
read -r -d '' ACPP <<'ACPP'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (MAX(?count) as ?max) (MIN(?count) as ?min) (AVG(?count) as ?avg)
FROM <http://localhost:3030/ds/spek>
WHERE {
  SELECT (COUNT(DISTINCT(?candi)) as ?count)
  WHERE {
    ?candi slowmo:AncestorPerformer ?perf .
    ?candi slowmo:acceptable_by ?path .
    ?candi a obo:cpo_0000053 .
  }
  GROUP BY ?perf
}
ACPP

# Min, Max, Ave number of candidates per performer
# Will never give min < 1.  Figure out how to find performers without candidates.
read -r -d '' CPP <<'CPP'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (MAX(?count) as ?max) (MIN(?count) as ?min) (AVG(?count) as ?avg)
FROM <http://localhost:3030/ds/spek>
WHERE {
  SELECT (COUNT(?candi) as ?count)
  WHERE {
    ?candi slowmo:AncestorPerformer ?perf .
    ?candi a obo:cpo_0000053 .
  }
  GROUP BY ?perf
}
CPP

read -r -d '' CLEAR_ACCEPTS <<CLRACCP
PREFIX slowmo: <http://example.com/slowmo#>

WITH <http://localhost:3030/ds/spek>
DELETE { ?s slowmo:acceptable_by ?o }
WHERE { ?s slowmo:acceptable_by ?o . }
CLRACCP

JQ_FMT_CAND='(.results.bindings[0] | map(.value))[0]'
JQ_FMT_PATH='.results.bindings | map("\($step),path,accepted_count,\(.path.value),\(.count.value)") | .[]'
JQ_FMT_ANNO='.results.bindings | map("\($step),anno,count,\(.dtype.value),\(.count.value)") | .[]'
JQ_FMT_ACPP='.results.bindings | .[] | to_entries[] | "\($step),perf,\(.key),acceptable_candidates,\(.value.value)"'
JQ_FMT_CPP='.results.bindings | .[] | to_entries[]  | "\($step),perf,\(.key),candidates,\(.value.value)"'
JQ_FMT_PPTH='.results.bindings | map("\($step),path,perf_count,\(.path.value),\(.count.value)") | .[]'

# prepend the give step name, $1 to the output.
emit_step(){
  STEP=${1:-'n'}
  RES=$(s-query --server "http://localhost:3030/ds" "${QCANDI}" | jq "${JQ_FMT_CAND}")
  echo -e "${STEP},candi,count,all,${RES}"

  RES=$(s-query --server "http://localhost:3030/ds" "${ACCEPTED}" | jq "${JQ_FMT_CAND}")
  echo -e "${STEP},candi,accepted_count,all,${RES}"

  RES=$(s-query --server "http://localhost:3030/ds" "${ANCEST}" | jq "${JQ_FMT_CAND}")
  echo -e "${STEP},candi,uniq_perf_count,all,${RES}"

  RES=$(s-query --server "http://localhost:3030/ds" "${ACCANDI}" | jq "${JQ_FMT_CAND}")
  echo -e "${STEP},perf,count,with_accept,${RES}"

  s-query --server "http://localhost:3030/ds" "${CPATHS}" |\
    jq --arg step "${STEP}" "${JQ_FMT_PATH}" | tr -d '"'
  s-query --server "http://localhost:3030/ds" "${ANNOS}"  |\
    jq --arg step "${STEP}" "${JQ_FMT_ANNO}" | tr -d '"'
  s-query --server "http://localhost:3030/ds" "${CPP}"    |\
    jq --arg step "${STEP}" "${JQ_FMT_CPP}"  | tr -d '"'
  s-query --server "http://localhost:3030/ds" "${ACPP}"   |\
    jq --arg step "${STEP}" "${JQ_FMT_ACPP}" | tr -d '"'
  s-query --server "http://localhost:3030/ds" "${PERFPATHS}" |\
    jq --arg step "${STEP}" "${JQ_FMT_PPTH}" | tr -d '"'
}

# Swap type $1 for type $2
# use prefixes like obo:psdo_00000XX and slowmo:Whatever 
swp_type(){
  FROM_TYPE=$1
  TO_TYPE=$2

read -r -d '' SWPTYPE <<SWPTYPE
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

WITH <http://localhost:3030/ds/spek>
DELETE { ?s a <${FROM_TYPE}> }
INSERT { ?s a <${TO_TYPE}> } 
WHERE { 
  ?s a <${FROM_TYPE}> .
}
SWPTYPE

curl -silent -X POST --data-binary "${SWPTYPE}" \
  --header 'Content-type: application/sparql-update' \
  'http://localhost:3030/ds/update' 1> /dev/null 2>&1
} # End of swt_type function

# Clear the acceptable by candidates
clear_accepted(){
curl -silent -X POST --data-binary "${CLEAR_ACCEPTS}" \
  --header 'Content-type: application/sparql-update' \
  'http://localhost:3030/ds/update' 1> /dev/null 2>&1
}

#Original Annotations
NEGATIVE_TREND="http://purl.obolibrary.org/obo/psdo_0000100"
POSITIVE_TREND="http://purl.obolibrary.org/obo/psdo_0000099"
NEGATIVE_GAP="http://purl.obolibrary.org/obo/psdo_0000105"
POSITIVE_GAP="http://purl.obolibrary.org/obo/psdo_0000104"
ACHIEVEMENT="http://example.com/slowmo#Achievement"

O_ANNOS=("${NEGATIVE_TREND}" "${POSITIVE_TREND}"\
  "${NEGATIVE_GAP}" "${POSITIVE_GAP}" "${ACHIEVEMENT}")

#Stepping Annotations bases. _n gets appended
ST_NEGATIVE_TREND="http://example.com/slowmo#negative_trend"
ST_POSITIVE_TREND="http://example.com/slowmo#positive_trend"
ST_NEGATIVE_GAP="http://example.com/slowmo#negative_gap"
ST_POSITIVE_GAP="http://example.com/slowmo#positive_gap"
ST_ACHIEVEMENT="http://example.com/slowmo#achievement"

ST_ANNOS=("${ST_NEGATIVE_TREND}" "${ST_POSITIVE_TREND}"\
  "${ST_NEGATIVE_GAP}" "${ST_POSITIVE_GAP}" "${ST_ACHIEVEMENT}")

# Step from given step number, $1, to next step.
# e.g. step_from "2" modifies annotations to go from 2 to 3.
# obo:psdo_0000085 becomes slowmo:positive_gap_2
# slowmo:positive_gap_3 becomes obo:psdo_0000085
step_from(){
  ARRAY_LEN=${#O_ANNOS[@]}
  THIS_N=${1}
  NEXT_N=$(expr ${THIS_N} + 1)

  for (( i=0; i<${ARRAY_LEN}; i++ )); do
    OLD_PRED="${ST_ANNOS[${i}]}_${THIS_N}"
    NEW_PRED="${ST_ANNOS[${i}]}_${NEXT_N}"

    # echo "${O_ANNOS[${i}]} -> ${OLD_PRED}"
    swp_type "${O_ANNOS[${i}]}" "${OLD_PRED}" 

    # echo "${NEW_PRED} -> ${O_ANNOS[${i}]}"
    swp_type "${NEW_PRED}" "${O_ANNOS[${i}]}" 
  done

  # Clear acceptability of candidates 
  clear_accepted

  # Re-evaluate acceptable candidates
  thinkpudding.sh --update-only
}

# Print header
echo "step,subject,what,which,value"

# Step back through annotations 1 to 5
for (( j=0; j<6; j++ )); do
  emit_step "${j}" | sort
  step_from "${j}"
done
