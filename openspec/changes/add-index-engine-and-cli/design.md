# Design

## Context

The engine already exists and is proven against Hugo. This change is mostly a move
with a new module boundary, plus small additions: a format version field and a
release pipeline. The risk sits in the move, not in the algorithms.

## Goals and Non-Goals

Goals:

- The same `Build` and `Emit` behaviour, byte for byte.
- A public package that `linny-mcp-server` and `linny.vim` can depend on.
- One binary, `lindexer`, installable without Nix.
- A format version the plugin can check.

Non-goals:

- New index features, ranking changes, or incremental rebuilds.
- MCP tools or server code.
- Changing notebook configuration formats.

## Decisions

### Package layout

```
index/          public engine: Build, Emit, Graph, BuildReport, Store
hugoref/        embedded reference site, used by verify --hugo
cmd/lindexer/   CLI
corpus/         synthetic notebook generator for tests and fixtures
internal/buildinfo/  version stamped by ldflags
```

`internal/index` becomes `index` unchanged apart from the identifier
`internal/index` in test imports. `hugoref` stays a separate package because it
pulls in an embedded site and belongs to verification, not to building.

### Public API

The move keeps the call shapes the MCP server already uses:

```go
func Build(root string) (*Graph, *BuildReport, error)
func Emit(g *Graph, indexRoot string) error
func OpenStore(path string) (*Store, error)
func LoadNotebookMeta(root string) NotebookMeta
func NormalizeTerm(term string) string
func TermValues(v any) (terms []string, ok bool)
```

`Graph`, `BuildReport`, `Store`, `DocRef`, `NotebookMeta`, and `TermMembership`
become public types. Any helper that the CLI needs but the server does not stays
unexported until a caller needs it.

### Format version

`_indexer_info.json` gains `index_format_version`, an integer starting at `1`.
The rule: additive fields do not bump it; a rename, removal, or semantic change to
an existing field does. Consumers refuse to read an index whose version is above
what they support, and warn below their minimum.

### Version stamping

`internal/buildinfo.Version` is stamped from `VERSION` through the flake ldflags
and through goreleaser. `lindexer version` prints it. `_indexer_info.json`
reports it as `product_version`. Development builds report `0.1.0-dev` or the Go
build info fallback.

### Watch and store

`watch` still requires `--state-dir`, because the SQLite store lives there and
debouncing uses it. `--index` stays optional; when set, each rebuild re-emits the
JSON tree. `linny.vim` passes a cache directory under `stdpath('cache')`.

### Release pipeline

`goreleaser` builds `CGO_ENABLED=0` for `linux/amd64`, `linux/arm64`,
`darwin/amd64`, and `darwin/arm64`, publishes a checksum file, and uses the
`VERSION` value as the tag. No install script and no self-update: users download a
binary and put it on `PATH`, the same way they install `fred`.

### Coverage floors

The new repository inherits 70 percent overall and 80 percent for `index`. The
flake check runs the same numbers, so `nix flake check` fails below them.

### Spec ownership

The seven index capabilities move here with their requirements, and
`linny-mcp-server` removes them. The format document lives in this repository so
the emitter and the document cannot drift.

## Risks and Trade-offs

- A move this size can change behaviour silently. Mitigation: run the existing
  suite here before deleting anything in the old repository, and compare emitted
  trees with `lindexer verify --reference`.
- Two repositories version independently. The server must bump its dependency to
  pick up engine fixes; that is visible in `go.mod`.
- goreleaser adds a tool to the dev shell. It is already installed on the
  maintainer machine and available in nixpkgs.

## Migration

1. Copy the packages and tests into this repository under the new paths.
2. Fix imports, add `internal/buildinfo`, build, and run the suite.
3. Add the format version field and its test.
4. Cut `0.1.0`, then let `linny-mcp-server` depend on the tag.
5. Archive this change and delete the moved specs there.
