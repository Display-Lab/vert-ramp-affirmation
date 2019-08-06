#!/usr/bin/env bash

# Require arg is a directory
if [[ ! -d $1 ]]
then
  echo "${1} is not a directory"
  exit 1
fi

# Known good URI patterns
read -r -d '' EXEMPT_PATTERNS <<'HEREDOC'
^http$
^http_.*
^http\..*
http://localhost.*
http://www\.w3\.org/2000/01/rdf-schema
http://schema\.org.*
http://purl\.org/dc/.*
http://www\.w3\.org/ns/csvw.*
http://www\.inkscape\.org/.*
https://raw\.githubusercontent\.com.*
http://www\.apache\.org/licenses.*
https://zenodo\.org.*
http://sodipodi\.sourceforge\.net/DTD/sodipodi-0\.dtd
http://scripts\.sil\.org/OFL
http://www\.w3\.org/1999/02/22-rdf-syntax-ns
http://www\.w3\.org/1999/xlink
http://www\.w3\.org/2000/svg
http://www\.w3\.org/2001/XMLSchema
https://fonts\.google\.com/specimen/Montserrat
https://github\.com/JulietaUla/Montserrat
http://www.inkscape.org
http://creativecommons.org/ns
http://purl\.obolibrary\.org/obo
http://purl\.obolibrary\.org/obo/psdo
http://purl\.obolibrary\.org/obo/cpo
HEREDOC

# step 1 find all urls in files. grep or ag
URIS_PATH=/tmp/uris

# Find urls in files in directory
#   excluding dot directories like .git
#   exclude known good uri patterns
grep -I --exclude='*.csv' --exclude='*.json'\
  --exclude-dir='.git' -o -h -e "http[^]' @!$&()*+,;=%]*" -r ${1} |\
  sed 's;[^[:alnum:]]*$;;g' |\
  sort |\
  uniq |\
  grep --invert-match -f <(echo -n "${EXEMPT_PATTERNS}") |\
  cat > ${URIS_PATH}

# Get the uris from the ontologies
ONTOS_PATH=/tmp/onto_uris
if [[ ! -f ${ONTOS_PATH} ]]
then
  ./onto_extract.rb | sort | uniq > ${ONTOS_PATH}
fi

# step 4 compare urls from files with onto urls. comm
# Compare URIS to ONTOS: 
#  Lines that are "new" to the DIR, ignore. These are lines in the ontologies not in the dir.
#  Lines that are "unchanged" are those in the DIR and found in the ontology. Ignore these.
# The important ones are lines that old from the point of view of the DIR
#  They are not found in ontology.
diff --new-line-format="" --unchanged-line-format="" ${URIS_PATH} ${ONTOS_PATH}
