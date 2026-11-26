#!/usr/bin/env bash
set -euo pipefail

PHASE="${1:-before}"
DIR="reports/$PHASE"
mkdir -p "$DIR"

make all asan

: > "$DIR/valgrind.log"
: > "$DIR/asan.log"

run_case() {
    local log="$1"
    local name="$2"
    local rc=0
    shift 2

    echo "=== $name ===" >> "$log"
    "$@" >> "$log" 2>&1 || rc=$?
    echo "Exit code: $rc" >> "$log"
}

LONG_NAME=$(printf 'A%.0s' {1..32})

for tool in valgrind asan; do
    if [ "$tool" = valgrind ]; then
        cmd=(valgrind --leak-check=full
             --show-leak-kinds=all
             --error-exitcode=42
             ./build/records)
    else
        cmd=(env ASAN_OPTIONS=detect_leaks=1:halt_on_error=1
             ./build/records-asan)
    fi

    log="$DIR/$tool.log"

    run_case "$log" "Normal list" "${cmd[@]}" list
    run_case "$log" "Normal add" "${cmd[@]}" add Keyboard
    run_case "$log" "Search record" "${cmd[@]}" search Laptop
    run_case "$log" "Delete record" "${cmd[@]}" delete Monitor
    run_case "$log" "Boundary input" "${cmd[@]}" add "$LONG_NAME"
done

echo "=== Reports saved ==="
ls -lh "$DIR"
