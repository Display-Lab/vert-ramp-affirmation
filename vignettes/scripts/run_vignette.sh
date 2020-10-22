#!/usr/bin/env bash
# This is designed to be run from within a vignette directory
# Assumes bitstomach.sh, cansmash, fuseki-server, and thinkpudding.sh are on PATH.

# Create outputs directory
mkdir outputs

# Run bitstomach on performance data, spek, and annotations
bitstomach.sh -s spek.json -d performance.csv -a annotations.r | jq . > outputs/spek_bs.json

# Run candidate smasher on spek (spek_bs.json) and templates
cansmash --path=outputs/spek_bs.json --md-source=templates.json
