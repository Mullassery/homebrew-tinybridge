# Audit Report: homebrew-tinybridge
Date: 2026-10-26 | Type: Read-only systems design audit  
Repo: ../homebrew-tinybridge (local: /Users/georgimullassery/Desktop/Projects/homebrew-tinybridge) | Branch: main | Status: clean

## Overview
Custom Homebrew tap for TinyBridge (Linux VMs on macOS via Apple Virtualization.framework). Contains formulas (`Formula/tinybridge.rb`, `Formula/tinybridged.rb`), docs, LICENSE, SECURITY.md, tools, USE_CASES.md.

## Architecture / Entry points
- Tap consumed via `brew tap mullassery/tinybridge <repo>`; installs `tinybridge` (CLI) and/or `tinybridged` (daemon/service). `tinybridged` depends on `tinybridge`.
- Assets fetched from GitHub Releases of Mullassery/tinybridge.

## Dependencies / Packaging
- Homebrew Ruby DSL. Depends on macOS :ventura (both formulas). Only arm64 published per README.
- `tinybridge.rb` v0.6.3 (url points to v0.6.3-aarch64-apple-darwin.tar.gz, sha256 88914047...). 
- `tinybridged.rb` v0.6.1 (url points to v0.6.1-aarch64-apple-darwin.tar.gz, sha256 ae8a95e8...). 
- `tinybridged` declares `depends_on "tinybridge"`.

## Tests / CI
- CI: bump-formula.yml only. No unit tests in repo (find: 0 test files). Bump workflow suggests automated formula updates.
- No test blocks in formulas (`test do` present in both) — basic smoke tests exist.

## Security observations
- Checksums pinned per release asset (sha256). URLs point to GitHub Releases (HTTPS). 
- No curl/wget piped to shell in formulas. 
- README warns Intel unsupported (refuses install) — avoids confusing download failures.
- Tap is Git repo; Homebrew fetches via git/HTTPS.

## Findings
| ID | Severity | Category | Evidence | Impact | Root cause | Recommendation | Confidence |
|---|---|---|---|---|---|---|---|
| HBT-001 | High | Versioning/Documentation | Formula/tinybridge.rb:6-7 (v0.6.3), Formula/tinybridged.rb:6-7 (v0.6.1); README.md:10-14 states "Both formulas ... point at the real v0.6.1 release asset" | Users following README may expect same version; `tinybridged` depends on `tinybridge` but different release assets could mismatch if APIs change between versions. | Doc drift / manual updates out of sync. | Align versions or explicitly document compatibility matrix; update README; consider bumping tinybridged to match or validate compatibility in test. | High |
| HBT-002 | Medium | Portability | README:20-27 states only Apple Silicon published, refuses Intel. No `on_intel` guard visible in formulas. | Intel Macs get unclear behavior. | Intentional limitation. | Add explicit `on_intel do` with `odie` or document in formula comments; ensure test coverage. | High |
| HBT-003 | Low | Operability | Only bump-formula.yml CI; no checksum verification of tap integrity, no CI test of formula install. | Formula regressions may not be caught. | Minimal CI. | Add CI job to `brew audit --strict` and `brew install` in a clean environment (or dry-run) on PRs. | Medium |

## Strengths
- Pinned checksums per asset. Clear separation of CLI/daemon formulas with dependency. Service integration documented.
- README honest about verification status and limitations.

## Prioritized remediation
1. Fix HBT-001 (version skew) — critical for correctness.
2. Add Intel guard / better messaging (HBT-002).
3. Strengthen CI (HBT-003).

## Limitations
Read-only audit of formulas/docs; did not run brew commands.
