# linden-index

The index engine behind Linny notebooks. It reads a notebook corpus, emits the
JSON index tree that `linny.vim` consumes, and keeps a disposable SQLite store for
search. It is extracted from `linny-mcp-server` so it can be released and installed
on its own, without Nix and without an MCP server.

The repository ships two things: the `index` Go package that other projects import,
and the `lindexer` CLI that `linny.vim` shells out to.

## Commands

```bash
go build ./...
go test ./...
golangci-lint run
nix flake check          # build, tests, lint, coverage gate
nix develop              # dev shell

# build and emit the index for a notebook
lindexer build --corpus <notebook> --index <notebook>/lindenIndex

# persist a state store and search it
lindexer build --corpus <notebook> --state-dir <dir>
lindexer search --state-dir <dir> "query"

# watch a corpus and re-emit JSON on change
lindexer watch --corpus <notebook> --state-dir <dir> --index <notebook>/lindenIndex

# compare the generated tree against a reference or against Hugo
lindexer verify --corpus <notebook> --reference <dir>
lindexer verify --corpus <notebook> --hugo
```

## Beans

When I refer to issues like linden-index-rn3b checkout the task
in @.beans/linden-index-rn3b-*.md

In this project we will use these tasks as epics for making openspec proposals.

WHEN you create a proposal at a link to this task in the proposal.md.
WHEN a bean is used to create an proposal change the status to "in-progress"
WHEN a proposal is archived add the link to the archived proposal in the frontmatter of this task like this:

```
openspec-link: openspec/changes/archive/....
```

You are allowed to update these statuses in the task frontmatter:

- in-progress
- todo
- draft
- completed
- scrapped

When making changes you are allowed to update the date/time in `updated_at` in the task frontmatter

Besides updating status and openspec-link, you are NOT ALLOWED to modify the contents of the task file.
