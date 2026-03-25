# Broken Deploy: Ruby/asdf Resolution in CI

## Summary

Deploy failed in `server-config` while generating `releases.yml` and `deploy-info.yml`:
- task: `create releases.yml and deploy-info.yml`
- script: `bin/create-releases-and-deploy-info`
- exit code: `126`

Observed error:
- `No preset version installed for command ruby`

At the same time, logs showed:
- `asdf current ruby` => `3.3.8`
- `asdf where ruby 3.3.8` => path exists
- but binary missing at `~/.asdf/installs/ruby/3.3.8/bin/ruby`
- ruby shim content still referenced old plugin entries (`3.1.3`, `3.3.6`)

So this was not just a stale shim; the asdf install state was inconsistent/corrupt.

## Root Cause

CI host had an inconsistent asdf ruby state:
- asdf metadata considered `ruby 3.3.8` installed
- effective ruby binary for that version was absent/unusable
- shim resolution then failed with "No preset version installed"

## Minimal Fix Implemented

### 1) Harden ruby setup in `bin/env/ruby-setup`

Behavior for asdf path now:
- read required ruby from `.tool-versions`
- run `asdf install ruby <required>`
- verify binary exists and is executable via:
  - `asdf where ruby <required>`
  - `<where>/bin/ruby`
- if missing:
  - `asdf uninstall ruby <required>` (best effort)
  - reinstall `asdf install ruby <required>`
- run `asdf reshim ruby <required>`

This adds self-healing for broken "installed but missing binary" states.

### 2) Keep release generation script minimal and deterministic

`bin/create-releases-and-deploy-info` now keeps only required logic:
- `asdf exec ruby bin/deploy_info.rb`
- `asdf exec ruby dev/releasenotes-md-to-yaml.rb`

It still falls back to plain `ruby` when `asdf` is not present.

## Why This Works

- `asdf exec` reduces dependency on shell shim quirks.
- reinstall-on-missing-binary addresses the real failure mode.
- `reshim` ensures shims are regenerated after install/repair.

## Validation

A CI run already showed:
- `WARNING: ruby 3.3.8 marked installed but binary missing; reinstalling`
- ruby source download/build/install for `3.3.8`
- deploy progressed past the former failure point into later tasks

No further `FAILED!` from the `server-config` release-generation step in that run.

Local verification after the minimal script cleanup:
- `bash -n bin/env/ruby-setup` passes
- `bash -n bin/create-releases-and-deploy-info` passes
- running `./bin/create-releases-and-deploy-info` no longer reproduces `No preset version installed for command ruby`; local run instead failed later with host-specific permission (`EPERM`) while writing under local asdf gem cache.

## Notes

- Keep `.tool-versions` as the ruby version source of truth.
- If this recurs in CI, investigate executor home/cache persistence under `~/.asdf`.
