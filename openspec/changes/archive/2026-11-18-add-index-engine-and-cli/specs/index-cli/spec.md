# index-cli Specification

## Purpose

Provides the `lindexer` command that builds, verifies, searches, and watches a
Linny notebook from a terminal or another program.

## ADDED Requirements

### Requirement: Build emits the index tree

`lindexer build` SHALL build and emit the index for the given corpus, and SHALL
persist a state store when `--state-dir` is given.

#### Scenario: Build and emit

- **WHEN** `lindexer build --corpus <corpus> --index <dir>` runs
- **THEN** the index tree is written under `<dir>`
- **AND** the command exits zero

#### Scenario: Build without an index directory

- **WHEN** `lindexer build --corpus <corpus>` runs without `--index`
- **THEN** no JSON tree is written
- **AND** the build still succeeds

#### Scenario: Build with a state directory

- **WHEN** `lindexer build --corpus <corpus> --state-dir <dir>` runs
- **THEN** a SQLite store is written under `<dir>`
- **AND** `lindexer search --state-dir <dir>` can query it

### Requirement: Search queries a persisted store

`lindexer search` SHALL run a ranked full-text query against an existing state
store and print the matching documents.

#### Scenario: Search returns matches

- **WHEN** `lindexer search --state-dir <dir> "term"` runs against a populated
  store
- **THEN** matching documents are printed in ranked order
- **AND** the command exits zero

#### Scenario: Search without a store

- **WHEN** `lindexer search --state-dir <dir> "term"` runs and no store exists
- **THEN** the command reports the missing store
- **AND** exits non-zero

### Requirement: Version reports the build version

`lindexer version` SHALL print the version stamped at build time.

#### Scenario: Version output

- **WHEN** `lindexer version` runs
- **THEN** it prints the stamped version on one line
- **AND** exits zero

### Requirement: Errors are actionable and exit non-zero

Every subcommand SHALL report a missing required flag or a missing path on
standard error and exit non-zero, without a stack trace.

#### Scenario: Missing corpus

- **WHEN** `lindexer build` runs without `--corpus`
- **THEN** it prints a usage error naming the flag
- **AND** exits non-zero

#### Scenario: Corpus does not exist

- **WHEN** a subcommand is given a corpus path that does not exist
- **THEN** it prints that path
- **AND** exits non-zero

### Requirement: Watch requires a state directory

`lindexer watch` SHALL require `--state-dir` and SHALL re-emit JSON only when
`--index` is also given.

#### Scenario: Watch without a state directory

- **WHEN** `lindexer watch --corpus <corpus>` runs
- **THEN** it exits non-zero and says `--state-dir` is required

#### Scenario: Watch with JSON output

- **WHEN** `lindexer watch --corpus <corpus> --state-dir <dir> --index <dir>` runs
- **THEN** the JSON tree is re-emitted after each rebuild
