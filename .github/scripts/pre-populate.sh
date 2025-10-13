#!/usr/bin/env bash
RUNNER_VERSIONS=$(gh api /repos/actions/runner/releases --paginate | jq -r '.[] | select(.created_at > "2019-12-19") .name' | sed 's/^v//g' | sort -V)
EXISTING_TAGS=$(git ls-remote --tags origin | awk -F'/' '{print $3}' | sed 's/\^{}//g' | sort -V)
MISSING_TAGS=$(grep -vxf <(echo -e "$EXISTING_TAGS") <(echo -e "$RUNNER_VERSIONS"))

for TAG in $MISSING_TAGS; do

  MAJOR_MINOR_VERSION=$(echo "$TAG" | awk -F. '{print $1"."$2}')
  if (( $(echo "$MAJOR_MINOR_VERSION >= 2.300" | bc -l) )); then
    UBUNTU_VERSION="22.04"
  else
    UBUNTU_VERSION="18.04"
  fi

  echo "Dispatching release workflow for version: $TAG"
  gh workflow run release.yaml -f version="$TAG" -f ubuntu_version="$UBUNTU_VERSION"
  sleep 30
done


