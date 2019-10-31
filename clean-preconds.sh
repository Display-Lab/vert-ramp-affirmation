#!/usr/bin/env bash

FBIN=/opt/fuseki/apache-jena-fuseki-3.10.0/bin

# Delete tmp json
rm /tmp/*.json

# Drop graphs
${FBIN}/s-delete "http://localhost:3030/ds" spek
${FBIN}/s-delete "http://localhost:3030/ds" seeps
