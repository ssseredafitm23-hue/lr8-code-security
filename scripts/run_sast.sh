#!/usr/bin/env bash
set -eo pipefail

PHASE="${1:-before}"
mkdir -p "reports/$PHASE"

echo "=== Cppcheck ==="
cppcheck --enable=warning,style,performance,portability \
    --inconclusive --std=c11 src/ \
    2>&1 | tee "reports/$PHASE/cppcheck.log"

echo "=== GCC Static Analyzer ==="
gcc -std=gnu11 -O0 -g -Wall -Wextra -fanalyzer \
    -fdiagnostics-color=never -c -o build/records-analysis.o \
    src/records.c \
    2>&1 | tee "reports/$PHASE/gcc-analyzer.log"

echo "=== Reports saved ==="
ls -lh "reports/$PHASE/"
