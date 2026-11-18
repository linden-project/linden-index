# Changelog

All notable changes to this project are documented here. The format follows
Keep a Changelog, and the project uses semantic versioning.

## [Unreleased]

### Added

- Initial repository scaffolding: OpenSpec, Beans, flake, and the ship script.
- The `index` package: corpus build, JSON emission, SQLite+FTS5 store, search,
  watch, and reference verification.
- The `lindexer` CLI with `build`, `search`, `verify`, `watch`, and `version`.
- `index_format_version` in `_indexer_info.json`.
- The embedded Hugo reference site for `verify --hugo`.
- Nix package, flake checks, goreleaser config, and the release script.
