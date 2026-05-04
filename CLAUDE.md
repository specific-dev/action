# CLAUDE.md

GitHub Action that wraps the Specific CLI for use in users' workflows.

## Design

- Single composite action at the repo root (`action.yml`). Users reference `specific-dev/action@v1`.
- A discriminator input `command` selects what to do; common parameters (`version`, `api-url`, `audience`) are typed inputs.
- CLI is installed by `scripts/install.sh`, a runner-tailored variant of `https://specific.dev/install.sh`: no shell-profile editing, no analytics, requires `SPECIFIC_VERSION`. The action resolves `latest` to a concrete version first so the cache key is stable. The binary is cached via `actions/cache` keyed on `os/arch/version`.
- Authentication uses GitHub OIDC. The user's job sets `permissions: id-token: write`; the action (or CLI) trades the runner-injected `ACTIONS_ID_TOKEN_REQUEST_URL` / `ACTIONS_ID_TOKEN_REQUEST_TOKEN` for a JWT with audience `specific.dev` and sends it as a bearer token.
- Production API: `https://api.prod.specific.dev`. Overridable per-call via the `api-url` input for staging or development.

## v1

Only `command: verify` is supported. It hits `GET /auth/github-oidc/whoami` to confirm the OIDC trust relationship end-to-end. Implemented inline in the action (curl + jq); the CLI does not yet have a `verify` subcommand.

## Roadmap

Real commands (`deploy`, etc.) should shell out to `specific <command>` rather than reimplementing logic in the action. That requires the CLI to auto-resolve auth, with this priority: explicit `SPECIFIC_TOKEN` env var, then GitHub OIDC (when `ACTIONS_ID_TOKEN_REQUEST_*` are set), then local credentials. CLI source lives in `~/Dev/SpecificInfra/packages/cli`.

Per-command typed inputs can be added later without breaking `@v1` consumers.

## Commits

Use conventional commit messages: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, etc.
