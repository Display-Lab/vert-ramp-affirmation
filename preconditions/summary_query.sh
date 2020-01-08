#!/usr/bin/env bash

# Querries spek graph and produces summary csv

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

SELECT (COUNT(?path) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:acceptable_by ?path .
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
  ?candi slowmo:AncestorPerformer ?perf
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
}
ACCANDI

# Count causal pathways accepts
read -r -d '' CPATHS <<'CPATHS'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT ?path (COUNT(?candi) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi slowmo:acceptable_by ?path .
}
GROUP BY ?path
CPATHS

# Count number of times each annotation occurs in performers
read -r -d '' ANNOS <<'ANNOS'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT ?dtype (COUNT(?dtype) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi a <http://purl.obolibrary.org/obo/cpo_0000053> .
  ?candi obo:RO_0000091 ?disp .
  ?disp a ?dtype .
}
GROUP BY ?dtype
ANNOS

# Min, Max, Ave number of acceptabl candidates per performer
# Will never give min < 1.  Figure out how to find performers without candidates.
read -r -d '' ACPP <<'ACPP'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (MAX(?count) as ?max) (MIN(?count) as ?min) (AVG(?count) as ?avg)
FROM <http://localhost:3030/ds/spek>
WHERE {
  SELECT (COUNT(?candi) as ?count)
  WHERE {
    ?candi slowmo:AncestorPerformer ?perf .
    ?candi slowmo:acceptable_by ?path .
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
  }
  GROUP BY ?perf
}
CPP

JQ_FMT_CAND='(.results.bindings[0] | map(.value))[0]'
JQ_FMT_PATH='.results.bindings | map("path,accepted_count,\(.path.value),\(.count.value)") | .[]'
JQ_FMT_ANNO='.results.bindings | map("anno,count,\(.dtype.value),\(.count.value)") | .[]'
JQ_FMT_ACPP='.results.bindings | .[] | to_entries[] | "perf,\(.key),acceptable_candidates,\(.value.value)"'
JQ_FMT_CPP='.results.bindings | .[] | to_entries[] | "perf,\(.key),candidates,\(.value.value)"'

SQ=/opt/fuseki/apache-jena-fuseki-3.10.0/bin/s-query

echo "subject,what,which,value"

RES=$($SQ --server "http://localhost:3030/ds" "${QCANDI}" | jq "${JQ_FMT_CAND}")
echo -e "candi,count,all,all,${RES}"

RES=$($SQ --server "http://localhost:3030/ds" "${ACCEPTED}" | jq "${JQ_FMT_CAND}")
echo -e "candi,accepted_count,all,${RES}"

RES=$($SQ --server "http://localhost:3030/ds" "${ANCEST}" | jq "${JQ_FMT_CAND}")
echo -e "candi,uniq_perf_count,all,${RES}"

RES=$($SQ --server "http://localhost:3030/ds" "${ACCANDI}" | jq "${JQ_FMT_CAND}")
echo -e "perf,count,with_accept,${RES}"

$SQ --server "http://localhost:3030/ds" "${CPATHS}" | jq "${JQ_FMT_PATH}" | tr -d '"'
#$SQ --server "http://localhost:3030/ds" "${ANNOS}"  | jq "${JQ_FMT_ANNO}" | tr -d '"'
$SQ --server "http://localhost:3030/ds" "${CPP}"    | jq "${JQ_FMT_CPP}"  | tr -d '"'
$SQ --server "http://localhost:3030/ds" "${ACPP}"   | jq "${JQ_FMT_ACPP}" | tr -d '"'

