#!/usr/bin/env bats

@test "missing ORGANIZATION exits 1 with message" {
    run env -i PATH="$PATH" bash "$BATS_TEST_DIRNAME/../start.sh"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing ORGANIZATION"* ]]
}

@test "missing ACCESS_TOKEN exits 1 with message" {
    run env -i PATH="$PATH" ORGANIZATION=test bash "$BATS_TEST_DIRNAME/../start.sh"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing ACCESS_TOKEN"* ]]
}
