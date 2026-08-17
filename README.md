# Homebrew Tap for TinyBridge

Custom Homebrew tap to install TinyBridge - run Linux environments on macOS with zero configuration.

## Status

Formulas `tinybridge` and `tinybridged` reference release artifacts with valid checksums.
`tinybridge-app` currently has a placeholder checksum — see Known Issues below.

### Supported Architectures

- **Apple Silicon** (M1, M2, M3, M4) - `aarch64-apple-darwin`
- **Intel Mac** - `x86_64-apple-darwin`

Homebrew automatically downloads the correct binary for your architecture.

## Quick Start

### 1. Add the Tap

```bash
brew tap Mullassery/tinybridge https://github.com/Mullassery/homebrew-tinybridge.git
```

### 2. Install TinyBridge

**Recommended - Full Installation (CLI + Daemon):**
```bash
brew install tinybridged
```
This installs both `tinybridge` (CLI) and `tinybridged` (daemon with auto-start).

**Alternative - CLI Only:**
```bash
brew install tinybridge
```
Installs just the command-line tool (no background daemon).

**Optional - Menu Bar App:**
```bash
brew install tinybridge-app
```
Native macOS menu bar application for visual environment management.

### 3. Create Your First Environment

```bash
# Create environment
tinybridge up myproject

# Enter the Linux shell
tinybridge shell myproject

# You're now in Ubuntu!
ubuntu@myproject:~$ uname -a
Linux myproject 6.12.4-generic #1 SMP ... x86_64 GNU/Linux
```

## What Gets Installed

### `tinybridge` (CLI)
- Command-line interface
- Installed to: `/usr/local/bin/tinybridge`
- Size: ~15MB

### `tinybridged` (Daemon)
- Background service managing environments
- Installed to: `/opt/homebrew/Cellar/tinybridged/*/bin/tinybridged`
- Auto-starts at boot via LaunchAgent
- Socket: `~/Library/Application Support/TinyBridge/tinybridge.sock`
- Logs to: `~/Library/Logs/tinybridged.log`
- Size: ~20MB

### `tinybridge-app` (Menu Bar)
- Native macOS menu bar application
- Installed to: `/Applications/TinyBridge.app`
- Optional - for visual environment management
- Size: ~50MB

## Commands Reference

### Basic Commands

```bash
# Create environment
tinybridge up myproject

# Enter environment
tinybridge shell myproject

# Stop environment
tinybridge down myproject

# Check status
tinybridge status myproject

# List all environments
tinybridge list
```

### Advanced Commands

```bash
# View logs
tinybridge logs myproject

# Checkpoint progress
tinybridge checkpoint myproject --name "after-deploy"

# Restore from checkpoint
tinybridge restore myproject --from "after-deploy"

# Adjust resources
tinybridge update myproject --cpu 8 --memory 16GB

# Forward ports
tinybridge forward myproject 8000:8000
```

## Managing the Daemon

### Check Daemon Status

```bash
launchctl list | grep tinybridged
```

### View Daemon Logs

```bash
# Real-time logs
tail -f ~/Library/Logs/tinybridged.log

# Last 50 lines
tail -50 ~/Library/Logs/tinybridged.log

# Check for errors
tail -f ~/Library/Logs/tinybridged-error.log
```

### Restart Daemon

```bash
launchctl stop com.mullassery.tinybridged
launchctl start com.mullassery.tinybridged
```

### Uninstall Daemon (keeps CLI)

```bash
launchctl unload ~/Library/LaunchAgents/com.mullassery.tinybridged.plist
rm ~/Library/LaunchAgents/com.mullassery.tinybridged.plist
```

## Updating

### Update TinyBridge

```bash
brew upgrade tinybridge
```

### Update Daemon

```bash
brew upgrade tinybridged
```

### Update Menu Bar App

```bash
brew upgrade tinybridge-app
```

## Uninstalling

### Remove Everything

```bash
# Uninstall formulas
brew uninstall tinybridge-app
brew uninstall tinybridged
brew uninstall tinybridge

# Remove tap
brew untap Mullassery/tinybridge

# Remove LaunchAgent
launchctl unload ~/Library/LaunchAgents/com.mullassery.tinybridged.plist
rm ~/Library/LaunchAgents/com.mullassery.tinybridged.plist

# Remove wrapper script
rm ~/.local/bin/tinybridged-start

# Clean up logs and sockets
rm -rf ~/Library/Logs/tinybridged*.log
rm -rf ~/Library/Application\ Support/TinyBridge
```

### Keep Daemon, Remove CLI

```bash
brew uninstall tinybridge
# Daemon continues running in background
```

## Troubleshooting

### Daemon Won't Start

```bash
# Check if already running
launchctl list | grep tinybridged

# Manually load LaunchAgent
launchctl load ~/Library/LaunchAgents/com.mullassery.tinybridged.plist

# Check logs
tail -f ~/Library/Logs/tinybridged.log
tail -f ~/Library/Logs/tinybridged-error.log

# Manually start daemon for debugging
~/.local/bin/tinybridged-start
```

### Permission Denied Installing

```bash
# If getting permission errors:
# Make sure /usr/local/bin is writable
ls -la /usr/local/bin

# If not owned by you:
sudo chown -R $USER:$GROUP /usr/local/bin
```

### CLI Can't Connect to Daemon

```bash
# Verify socket exists
ls -la ~/Library/Application\ Support/TinyBridge/tinybridge.sock

# Check daemon is running
launchctl list | grep tinybridged

# Check daemon logs
tail -f ~/Library/Logs/tinybridged.log

# Restart daemon
launchctl stop com.mullassery.tinybridged
launchctl start com.mullassery.tinybridged
```

### Menu Bar App Won't Launch

```bash
# Launch from Terminal for debugging
/Applications/TinyBridge.app/Contents/MacOS/TinyBridgeApp

# Check permissions
ls -la /Applications/TinyBridge.app

# Try reinstalling
brew reinstall tinybridge-app
```

### Out of Disk Space

```bash
# Check disk usage
df -h

# Clean up old environments
tinybridge list
tinybridge delete old-project --force

# Clear TinyBridge cache
rm -rf ~/.cache/tinybridge
```

## Development

### Local Testing

```bash
# Tap locally for testing
brew tap-new test/local ~/test-tap
cp Formula/* ~/test-tap/Formula/

# Test install
brew install test/local/tinybridge

# Test uninstall
brew uninstall test/local/tinybridge
```

### Modify Formulas

```bash
# Clone this repo
git clone https://github.com/Mullassery/homebrew-tinybridge.git
cd homebrew-tinybridge

# Edit Formula files
vi Formula/tinybridge.rb

# Test locally
brew tap-new local /path/to/homebrew-tinybridge
brew install local/tinybridge
```

## Known Issues

- `Formula/tinybridge-app.rb` has a placeholder `sha256`
  (`TODO_REPLACE_WITH_ACTUAL_SHA256`) instead of a real checksum. `brew install tinybridge-app`
  will fail until this is replaced with the actual checksum of the published `.dmg`.
- The `tinybridge` and `tinybridged` formulas reference checksums that are correctly formatted
  64-character SHA-256 values; they were not independently re-verified against the release
  assets as part of this audit.

## Support & Issues

- **Report bugs**: https://github.com/Mullassery/tinybridge/issues
- **Tap issues**: https://github.com/Mullassery/homebrew-tinybridge/issues
- **Documentation**: https://github.com/Mullassery/tinybridge

## License

This tap is released under a proprietary, attribution-required license — see
[LICENSE](LICENSE) in this repository for the full terms. TinyBridge itself is proprietary
software licensed separately by the main TinyBridge repository.
