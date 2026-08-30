# Homebrew Tap for TinyBridge

Custom Homebrew tap to install TinyBridge - run Linux environments on macOS with zero configuration.

## Status

Both formulas (`tinybridge`, `tinybridged`) point at the real v0.6.0 release
asset with a verified checksum, and have been installed and run end-to-end
as part of this pass (daemon started via `brew services`, CLI `--version`
and `--help` both work, `tinybridge-vmhost` resolves its bundled library via
its own embedded `@executable_path` rpath — no `DYLD_LIBRARY_PATH` wrapper
needed anymore as of v0.6.0). See Known Issues below for what's still
unverified upstream.

### Supported Architectures

- **Apple Silicon** (M1 and later) - `aarch64-apple-darwin`

Only an Apple Silicon build is currently published. There is no Intel
(`x86_64`) release artifact as of v0.6.0 — the formulas will refuse to
install on Intel Macs rather than fail with a confusing download error.

## Quick Start

### 1. Add the Tap

```bash
brew tap mullassery/tinybridge https://github.com/Mullassery/homebrew-tinybridge.git
```

### 2. Install TinyBridge

**Recommended - Full Installation (CLI + Daemon):**
```bash
brew install tinybridged
```
This installs both `tinybridge` (CLI) and `tinybridged` (daemon), since
`tinybridged` depends on `tinybridge`.

**Alternative - CLI Only:**
```bash
brew install tinybridge
```
Installs just the command-line tool (no background daemon).

### 3. Start the Daemon

```bash
brew services start tinybridged
```

### 4. Create Your First Environment

```bash
tinybridge launch myproject
tinybridge shell myproject
```

Guest boot to a real login prompt is verified working upstream as of
v0.6.0 — see Known Issues for what this install path still doesn't
automate (kernel/disk/seed image aren't bundled or auto-downloaded yet).

## What Gets Installed

### `tinybridge` (CLI)
- Command-line interface
- Symlinked to `$(brew --prefix)/bin/tinybridge`

### `tinybridged` (Daemon + VM host)
- `tinybridged`: background service managing environments
- `tinybridge-vmhost`: per-VM host process that drives Apple's
  Virtualization.framework (ad-hoc codesigned with the
  `com.apple.security.virtualization` entitlement at install time)
- Managed via `brew services` (`start`/`stop`/`restart`), not a manually
  written LaunchAgent
- Socket: `~/Library/Application Support/TinyBridge/tinybridge.sock`
- Logs: `$(brew --prefix)/var/log/tinybridge.log`

## Commands Reference

Real command list, from `tinybridge --help` (v0.6.0):

```
launch     Launch a new environment (primary command as of v0.5.0+)
up         Start an environment (legacy alias for launch)
gui        Attach display window to environment
headless   Detach display window from environment
down       Stop an environment
suspend    Suspend an environment (pause VM, preserves state)
resume     Resume a suspended environment
shutdown   Gracefully shutdown an environment
restart    Restart an environment
repair     Repair an environment
destroy    Destroy an environment
status     Show environment status
list       List all environments
shell      Open shell in environment
ssh        SSH into environment
logs       Show logs
update     Manage environment resources
snapshot   Manage environment snapshots
doctor     Run system diagnostics
templates  List available templates
images     List available images
dds        Manage DDS networking
```

Run `tinybridge <command> --help` for each command's actual flags — this
tap doesn't duplicate that reference here to avoid it going stale again.

## Managing the Daemon

```bash
# Status
brew services list | grep tinybridge

# Start / stop / restart
brew services start tinybridged
brew services stop tinybridged
brew services restart tinybridged

# Logs
tail -f "$(brew --prefix)/var/log/tinybridge.log"
```

## Updating

```bash
brew upgrade tinybridge tinybridged
```

## Uninstalling

```bash
brew services stop tinybridged
brew uninstall tinybridged tinybridge
brew untap mullassery/tinybridge

# Optional: remove runtime state
rm -rf ~/Library/Application\ Support/TinyBridge
```

## Troubleshooting

### Daemon won't start

```bash
brew services list | grep tinybridge
tail -f "$(brew --prefix)/var/log/tinybridge.log"
```

### CLI can't connect to daemon

```bash
ls -la ~/Library/Application\ Support/TinyBridge/tinybridge.sock
brew services restart tinybridged
```

## Development

```bash
git clone https://github.com/Mullassery/homebrew-tinybridge.git
cd homebrew-tinybridge

# Edit a formula, commit the change (brew tap clones from git, so it only
# sees committed state, not your working tree), then test locally:
brew tap mullassery/tinybridge-local "$(pwd)"
brew trust mullassery/tinybridge-local
brew install mullassery/tinybridge-local/tinybridge
```

## Known Issues

- Only Apple Silicon is supported; there is no Intel build published upstream.
- ~~`tinybridge-vmhost` had no rpath and needed a `DYLD_LIBRARY_PATH`
  wrapper workaround~~ — fixed upstream in v0.6.0: the binary now embeds
  `@executable_path`/`@loader_path` rpaths at link time
  (`crates/tinybridge-vmhost/build.rs`), so `tinybridged` installs it
  straight into `libexec` with a plain symlink from `bin`, no wrapper
  script needed. Verified end-to-end through the real installed symlink
  chain with an empty environment.
- Guest boot to a real login prompt is verified working upstream as of
  v0.6.0 (main repo's README "Honest status" section has the full story),
  but this install path still doesn't bundle or auto-download a kernel,
  disk image, or cloud-init seed — you'd need to supply those yourself.
  Don't rely on this tap for anything beyond local testing of the
  CLI/daemon/VM-host plumbing itself.

## Support & Issues

- **Report bugs**: https://github.com/Mullassery/tinybridge/issues
- **Tap issues**: https://github.com/Mullassery/homebrew-tinybridge/issues
- **Documentation**: https://github.com/Mullassery/tinybridge

## License

This tap is released under a proprietary, attribution-required license — see
[LICENSE](LICENSE) in this repository for the full terms. TinyBridge itself is proprietary
software licensed separately by the main TinyBridge repository.
