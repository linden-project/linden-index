# Releasing

The version lives in `VERSION`. Nothing else hardcodes it: the flake reads the
file for the Nix package, and goreleaser reads the tag for release binaries.

## Cut a release

1. Decide the new version and edit `VERSION`.
2. Commit through the normal flow and archive the change.
3. Run `scripts/release.sh` with `GITHUB_TOKEN` set.

The script refuses a dirty tree or an existing tag, creates `v$(cat VERSION)`,
pushes the tag, and runs `goreleaser release --clean`. It publishes four archives
and `checksums.txt`:

| OS     | Arch  |
| ------ | ----- |
| linux  | amd64 |
| linux  | arm64 |
| darwin | amd64 |
| darwin | arm64 |

All builds use `CGO_ENABLED=0`.

## Version rules

Before 1.0, a breaking change gets a minor bump and a fix gets a patch bump. The
move to 1.0.0 is a deliberate choice, not a side effect of a feature.

## Consumers

`linny.vim` installs the binary from a release. `linny-mcp-server` pins the module
version in `go.mod`. Bump the dependency there to pick up engine changes; the two
versions are independent.

## Index format

`index_format_version` in `_indexer_info.json` is separate from the release
version. Bump it only for a rename, removal, or semantic change to an existing
field, as described in `docs/linden-index-spec.md`.
