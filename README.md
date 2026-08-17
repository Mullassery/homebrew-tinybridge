# Homebrew Tap for TinyBridge

Custom Homebrew tap to install TinyBridge - run Linux environments on macOS with zero configuration.

## Status

Both formulas (`tinybridge`, `tinybridged`) point at the real v0.5.0 release
asset with a verified checksum, and have been installed and run end-to-end
as part of this pass (daemon started via `brew services`, CLI `--version`
and `--help` both work, the VM host process resolves its bundled library
correctly). See Known Issues below for what's still unverified upstream.

### Supported Architectures

- **Apple Silicon** (M1 and later) - `aarch64-apple-darwin`

Only an Apple Silicon build is currently published. There is no Intel
(`x86_64`) release artifact as of v0.5.0 — the formulas will refuse to
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

A full guest OS boot to a login prompt is not yet verified upstream — see
Known Issues.

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

Real command list, from `tinybridge --help` (v0.5.0):

```
launch     Launch a new environment (primary command as of v0.5.0)
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

# Edit a formula, then test locally:
brew install --formula Formula/tinybridge.rb
```

## Known Issues

- Only Apple Silicon is supported; there is no Intel build published upstream.
- `tinybridge-vmhost` was built without headerpad room for `install_name_tool
  -add_rpath`, so it can't have an rpath patched in post-download. The
  `tinybridged` formula works around this with a `DYLD_LIBRARY_PATH` wrapper
  script instead of patching the binary — verified working, but a proper fix
  is for the upstream build to link with `-headerpad_max_install_names` (or
  embed the rpath at link time) so this workaround isn't needed.
- Per the v0.5.0 release notes' own "Honest status" section: a full guest OS
  boot to a login prompt is not yet verified end-to-end (no bundled/
  auto-downloaded root filesystem image exists yet). Don't rely on this tap
  for anything beyond local testing of the CLI/daemon/VM-host plumbing itself.

## Support & Issues

- **Report bugs**: https://github.com/Mullassery/tinybridge/issues
- **Tap issues**: https://github.com/Mullassery/homebrew-tinybridge/issues
- **Documentation**: https://github.com/Mullassery/tinybridge

## License

This tap is released under a proprietary, attribution-required license — see
[LICENSE](LICENSE) in this repository for the full terms. TinyBridge itself is proprietary
software licensed separately by the main TinyBridge repository.
