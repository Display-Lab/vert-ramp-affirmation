#!/usr/bin/env bash

# Drop both causal pathway and spek graphs
#  Assumes s-delete is in PATH

# Drop graphs
s-delete "http://localhost:3030/ds" spek
s-delete "http://localhost:3030/ds" seeps
