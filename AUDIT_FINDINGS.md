# Audit findings — 2026-10-19

This file records the repository-specific findings from the portfolio audit
conducted on 2026-10-19. It is documentation only; no code or release artifacts
were changed in this pass unless explicitly noted under "Implementation status".

Sources: the repository's own README/source/workflows, GitHub metadata and
Actions runs, PyPI metadata, and official competitor documentation. Claims are
marked as verified, inferred, or open questions. "Absent" means not found in the
inspected repository/docs, not proof that it cannot exist.

## What it is

Homebrew tap for TinyBridge (CLI + daemon/vmhost).

## Verified strengths

- Checksummed arm64 formulas; `brew services` block; ad-hoc codesign with the virtualization entitlement; clear arm64 refusal.
- Formula installs the daemon/vmhost/dylib correctly.

## Verified gaps and user-facing risks

- `tinybridged` formula is pinned to v0.6.1 while `tinybridge` is v0.6.3 — CLI/daemon skew.
- README says both formulas are 0.6.1; no automated bump for the daemon formula; arm64 only.

## Direct competitors

- homebrew-core (Lima/Multipass), OrbStack cask, UTM cask.

## Ranked next actions

- P1: lockstep formula bump + CI version/checksum consistency check (S).
- P1: add an upgrade test 0.6.1 → 0.6.3 (S).

## Do not build

- Intel formula until an x86_64 artifact exists.

## Evidence gaps / validation needed

- No clean-machine install test in CI; no upgrade test.

## Recommended disposition

Maintain; it is the primary install path for TinyBridge.

## Implementation status

No code changes in this pass.
