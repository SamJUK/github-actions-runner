#!/usr/bin/env bash
set -uo pipefail

IMAGE="${1:-github-action-runner:test}"
fail=0

check() {
    local desc="$1"
    shift
    if "$@" >/dev/null 2>&1; then
        echo "[PASS] $desc"
    else
        echo "[FAIL] $desc"
        fail=1
    fi
}

check "curl present in image" docker run --rm --entrypoint curl "$IMAGE" --version
check "jq present in image" docker run --rm --entrypoint jq "$IMAGE" --version
check "runner binary installed" docker run --rm --entrypoint test "$IMAGE" -f /home/docker/actions-runner/run.sh

out=$(docker run --rm "$IMAGE" 2>&1)
if [[ "$out" == *"Missing ORGANIZATION"* ]]; then
    echo "[PASS] missing ORGANIZATION fails fast"
else
    echo "[FAIL] missing ORGANIZATION fails fast"
    fail=1
fi

out=$(docker run --rm -e ORGANIZATION=test "$IMAGE" 2>&1)
if [[ "$out" == *"Missing ACCESS_TOKEN"* ]]; then
    echo "[PASS] missing ACCESS_TOKEN fails fast"
else
    echo "[FAIL] missing ACCESS_TOKEN fails fast"
    fail=1
fi

exit $fail
