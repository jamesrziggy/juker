#!/bin/bash
# bench_http.sh — HTTP throughput benchmark for Kona proof_web
# Usage: ./bench_http.sh [port] [requests]
# Example: ./bench_http.sh 7777 2001

PORT=${1:-7777}
N=${2:-2001}

echo "--- $N requests -> localhost:$PORT ---"
ARGS=""
for i in $(seq 1 $((N-1))); do ARGS="$ARGS --next http://localhost:$PORT/api"; done
{ time curl -s -o /dev/null "http://localhost:$PORT/api" $ARGS ; } 2>&1 | grep -E "real|user|sys"
