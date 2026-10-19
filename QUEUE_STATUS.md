# Queue status — 2026-10-19

This file records what was shipped, what is blocked/failed, and what is rejected for this repository. It complements `AUDIT_FINDINGS.md`.

## Shipped
- Docs aligned with the public tap and CLI/daemon release flow.

## Blocked / failed
- `tinybridged` formula lags the CLI (0.6.1 vs 0.7.0); needs a lockstep bump after the next release.
- No Intel formula because upstream has no x86_64 artifact.

## Rejected / deferred
- Intel formula until an x86_64 release exists.

## Policy

Any future feature or upgrade must check `AUDIT_FINDINGS.md` and this file before implementation. A blocked item is retried only when its external dependency is available; a rejected item needs new user evidence or a design change to reopen.
