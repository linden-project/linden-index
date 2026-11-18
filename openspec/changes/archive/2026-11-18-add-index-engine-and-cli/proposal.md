# Proposal

## Why

`linny.vim` needs an indexer that works without Hugo and without Nix. That engine
already exists, but it lives in `linny-mcp-server` under `internal/`, so no other
module can import it and no user can install the CLI. Its name hides what it does
and ties its release cadence to the MCP server.

This repository gives the engine a name, a public import path, and its own binary.

## What Changes

- Create the Go module `github.com/linden-project/linden-index`.
- Move `internal/index` from `linny-mcp-server` to the public `index` package,
  behaviour unchanged.
- Move `internal/hugoref` for the Hugo reference comparison.
- Move `cmd/lindexer` with `build`, `search`, `verify`, `watch`, and `version`,
  same flags and exit codes.
- Add `index_format_version` to `_indexer_info.json` and document the
  compatibility contract.
- Release static `CGO_ENABLED=0` binaries for linux and darwin on amd64 and arm64,
  with checksums.
- Package `lindexer` in the flake and gate it with the 70 percent overall and 80
  percent core coverage floors.
- Take ownership of the index specs currently held by `linny-mcp-server`.

Not in this change: the `linny.vim` backend seam, the `linny-mcp-server` import
swap, the NixOS module, and any MCP tool.

## Capabilities

### New Capabilities

- `indexer`: builds the index tree from a notebook corpus.
- `index-format`: the emitted file layout and the format version contract.
- `index-store`: the disposable SQLite and FTS5 store.
- `index-verify`: compares two index trees.
- `index-watch`: rebuilds on corpus changes.
- `verify-hugo`: proves the output against a Hugo build.
- `synthetic-corpus`: deterministic fixtures for tests.
- `index-cli`: the `lindexer` command surface.
- `release-binaries`: versioned static releases with checksums.

### Modified Capabilities

None. This repository starts without specs.

## Impact

- New module, `go.mod`, `go.sum`, and the moved packages.
- `cmd/lindexer` and the release pipeline.
- Flake package, dev shell, and checks.
- Docs for installation and the index format.

Related work in other repositories: the backend seam in `linny.vim` and the
dependency swap in `linny-mcp-server`.

## Beans

- [linden-index-7ykc](../../../.beans/linden-index-7ykc--extract-internalindex-into-a-public-index-package.md)
  extract the public index package
- [linden-index-lwzj](../../../.beans/linden-index-lwzj--move-the-hugo-reference-and-verify-hugo.md)
  move the Hugo reference and verify
- [linden-index-jpov](../../../.beans/linden-index-jpov--publish-the-lindexer-cli-with-full-command-parity.md)
  CLI parity
- [linden-index-9xrs](../../../.beans/linden-index-9xrs--add-index-format-version-to-indexer-infojson.md)
  format version field
- [linden-index-zsab](../../../.beans/linden-index-zsab--cut-tagged-releases-with-static-binaries.md)
  tagged releases
- [linden-index-wuqz](../../../.beans/linden-index-wuqz--package-lindexer-in-the-flake-and-document-install.md)
  flake package and install docs
