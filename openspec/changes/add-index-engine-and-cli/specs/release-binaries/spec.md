# release-binaries Specification

## Purpose

Ships `lindexer` as a downloadable binary so notebook users can install it without
Nix, and makes every release identifiable and verifiable.

## ADDED Requirements

### Requirement: Static binaries for supported platforms

Each release SHALL provide `CGO_ENABLED=0` builds for linux and darwin on amd64
and arm64.

#### Scenario: Release archives

- **WHEN** a release is cut
- **THEN** archives exist for linux/amd64, linux/arm64, darwin/amd64, and
  darwin/arm64
- **AND** each archive contains the `lindexer` binary

#### Scenario: No C library dependency

- **WHEN** a release binary is inspected
- **THEN** it is statically linked and runs on a system without a matching libc

### Requirement: Checksums are published

Each release SHALL include a checksum file covering every archive.

#### Scenario: Checksum verification

- **WHEN** a user downloads an archive and the checksum file
- **THEN** the checksum matches the archive

### Requirement: VERSION drives the release tag

The release SHALL use the value in `VERSION` as the tag and stamp it into the
binary.

#### Scenario: Tag matches VERSION

- **WHEN** a release is cut from a tree with `VERSION` at `0.1.0`
- **THEN** the tag is `v0.1.0`
- **AND** `lindexer version` prints `0.1.0`

#### Scenario: Version is bumped once

- **WHEN** the version changes
- **THEN** only `VERSION` is edited

### Requirement: Installation is a download, not an installer

The README SHALL document downloading the archive for the user's platform,
verifying the checksum, and placing `lindexer` on `PATH`. The project SHALL NOT
download or update itself at runtime.

#### Scenario: Documented install

- **WHEN** the README is read
- **THEN** it shows the download and checksum steps for each platform
- **AND** it states that `lindexer` sits next to `fred` on `PATH`

#### Scenario: No self-update

- **WHEN** `lindexer` runs
- **THEN** it makes no network request to check for or fetch a newer version
