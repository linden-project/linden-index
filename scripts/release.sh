#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

VERSION="$(tr -d '[:space:]' < VERSION)"
TAG="v${VERSION}"

if [[ -z "$VERSION" ]]; then
  echo "release: VERSION is empty" >&2
  exit 1
fi
if git rev-parse -q --verify "refs/tags/${TAG}" >/dev/null; then
  echo "release: tag ${TAG} already exists" >&2
  exit 1
fi
if [[ -n "$(git status --porcelain)" ]]; then
  echo "release: working tree is not clean" >&2
  exit 1
fi
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "release: GITHUB_TOKEN is required" >&2
  exit 1
fi

git tag -a "$TAG" -m "$TAG"
jj git push --tag

goreleaser release --clean

echo "==> released ${TAG}"
