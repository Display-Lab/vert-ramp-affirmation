#!/usr/bin/env bash
# This is designed to be run from within a vignette directory
# Assumes bitstomach.sh, cansmash, fuseki-server, and thinkpudding.sh are on PATH.

# Create outputs directory
mkdir -p outputs

# Run bitstomach on performance data, spek, and annotations
echo "Running BitStomach"
bitstomach.sh -s spek.json -d performance.csv -a annotations.r 2> vignette.log | jq . > outputs/spek_bs.json

# Run candidate smasher on spek (spek_bs.json) and templates
echo "Running CandidateSmasher"
cansmash --path=outputs/spek_bs.json --md-source=templates.json 2>> vignette.log | jq . > outputs/spek_cs.json

# Run think pudding on spek (spek_cs.json) and causal pathways
echo "Running ThinkPudding"
thinkpudding.sh -s outputs/spek_cs.json -p causal_pathways.json 2>> vignette.log > outputs/spek_tp.json

echo "Stderr written to vignette.log"
