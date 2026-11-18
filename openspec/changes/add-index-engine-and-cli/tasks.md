# Tasks

## 1. Module and engine

- [ ] 1.1 Add `go.mod` for `github.com/linden-project/linden-index` on the Go
      version the engine already uses.
- [ ] 1.2 Copy `internal/index` to `index` and update test imports.
- [ ] 1.3 Copy the test fixtures the engine needs.
- [ ] 1.4 Copy `internal/buildinfo` to `internal/buildinfo` here.
- [ ] 1.5 `go build ./...` and `go test ./...` with the copied suite.

## 2. Format version

- [ ] 2.1 Add `index_format_version` to the `_indexer_info.json` writer.
- [ ] 2.2 Assert the field and its integer type in the emitter tests.
- [ ] 2.3 Document the bump rule in the format document.

## 3. Hugo reference and verification

- [ ] 3.1 Copy `internal/hugoref` to `hugoref`, including the embedded site.
- [ ] 3.2 Copy the synthetic corpus generator and its fixtures.
- [ ] 3.3 Keep `verify --reference` and `verify --hugo` behaviour unchanged.

## 4. CLI

- [ ] 4.1 Copy `cmd/lindexer` with `build`, `search`, `verify`, `watch`, and
      `version`.
- [ ] 4.2 Keep `--state-dir` required for `watch` and optional for `build`.
- [ ] 4.3 Print the stamped version from `internal/buildinfo`.
- [ ] 4.4 Test each subcommand's success path and its missing-flag error.

## 5. Packaging

- [ ] 5.1 Set the real `vendorHash` in `nix/package.nix` and make the flake
      package build.
- [ ] 5.2 Run the 70 percent overall and 80 percent `index` coverage gates
      through `nix flake check`.
- [ ] 5.3 Add `goreleaser` config with four platform targets, checksums, and no
      CGO.
- [ ] 5.4 Add a release script or CI workflow that tags `v$(cat VERSION)`.

## 6. Docs and specs

- [ ] 6.1 Write `README.md` with the install steps and a command overview.
- [ ] 6.2 Move the index format document here and link it from the README.
- [ ] 6.3 Add `RELEASING.md` describing the tag and goreleaser flow.
- [ ] 6.4 Confirm the moved specs validate and no requirement still points at
      `linny-mcp-server` paths.

## 7. Consumers

- [ ] 7.1 Tag `v0.1.0` so `linny-mcp-server` and `linny.vim` can pin it.
- [ ] 7.2 Report the tag to the `linny-mcp-server` change
      `extract-linden-index-module` and the `linny.vim` change
      `replace-hugo-with-lindexer`.
