# linden-index

The index engine behind Linny notebooks. It reads a notebook corpus and emits the
JSON index tree that [linny.vim](https://github.com/linden-project/linny.vim) uses
for menus, taxonomy views, dashboards, and search. It also keeps a disposable
SQLite store for full-text search.

It runs without Hugo and without Nix. `linny.vim` shells out to the `lindexer`
binary, the same way it calls `fred`.

## Install

Download the archive for your platform from the
[releases page](https://github.com/linden-project/linden-index/releases), verify
the checksum, and put the binary on your `PATH` next to `fred`.

```bash
curl -LO https://github.com/linden-project/linden-index/releases/download/v0.1.0/lindexer_0.1.0_linux_amd64.tar.gz
curl -LO https://github.com/linden-project/linden-index/releases/download/v0.1.0/checksums.txt
sha256sum --check --ignore-missing checksums.txt
tar xzf lindexer_0.1.0_linux_amd64.tar.gz
install -m 0755 lindexer ~/.local/bin/lindexer
```

With Nix:

```bash
nix profile install github:linden-project/linden-index
```

## Use

```bash
lindexer build --corpus ~/notes --index ~/notes/lindenIndex

lindexer build --corpus ~/notes --state-dir ~/.cache/linny/notes
lindexer search --state-dir ~/.cache/linny/notes "meeting notes"

lindexer watch --corpus ~/notes --state-dir ~/.cache/linny/notes --index ~/notes/lindenIndex

lindexer verify --corpus ~/notes --reference /tmp/reference-index
lindexer verify --corpus ~/notes --hugo
```

`watch` requires `--state-dir`; it re-emits JSON only when `--index` is given.
The index directory is a cache. Deleting it and rebuilding is always safe.

## Format

The emitted files and their shapes are documented in
[docs/linden-index-spec.md](docs/linden-index-spec.md). `_indexer_info.json`
carries `index_format_version`; consumers check it before reading the tree.

## Build

```bash
go build ./...
go test ./...
nix flake check
```

## Related

- [linny.vim](https://github.com/linden-project/linny.vim) consumes the index.
- [linny-mcp-server](https://github.com/linden-project/linny-mcp-server) exposes a
  notebook over MCP and imports the `index` package.
