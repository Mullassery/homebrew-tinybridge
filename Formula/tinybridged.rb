# frozen_string_literal: true

class Tinybridged < Formula
  desc "TinyBridge daemon - Linux environment manager backend"
  homepage "https://github.com/Mullassery/tinybridge"

  on_macos do
    on_arm do
      url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.0/tinybridged-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "6908da9b2947ff46fa2591a4eff33cd78f7273611edf78ca374794dc9afed9ed"
    end
    on_intel do
      url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.0/tinybridged-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "6908da9b2947ff46fa2591a4eff33cd78f7273611edf78ca374794dc9afed9ed"
    end
  end

  license "Apache-2.0"
  depends_on "tinybridge"

  def install
    bin.install "tinybridged"
  end

  def post_install
    puts "✅ TinyBridge daemon installed!"
    puts ""
    puts "Configuring daemon auto-start..."

    # Create LaunchAgents directory if needed
    system("mkdir -p #{ENV['HOME']}/Library/LaunchAgents")

    # Create LaunchAgent plist
    plist_path = "#{ENV['HOME']}/Library/LaunchAgents/com.tinybridge.daemon.plist"
    plist_content = <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>com.tinybridge.daemon</string>
          <key>ProgramArguments</key>
          <array>
              <string>#{HOMEBREW_PREFIX}/bin/tinybridged</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
              <key>SuccessfulExit</key>
              <false/>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{ENV['HOME']}/Library/Logs/tinybridge.log</string>
          <key>StandardOutPath</key>
          <string>#{ENV['HOME']}/Library/Logs/tinybridge.log</string>
      </dict>
      </plist>
    PLIST

    # Write plist file
    File.write(plist_path, plist_content)
    system("chmod 644 #{plist_path}")

    # Load the LaunchAgent
    system("launchctl load #{plist_path}")

    puts "✅ Daemon configured for auto-start"
    puts ""
    puts "Checking daemon status..."
    sleep 1
    if system("launchctl list | grep com.tinybridge.daemon")
      puts "✅ Daemon is running!"
    else
      puts "ℹ️  Daemon will start shortly..."
    end
    puts ""
    puts "View daemon logs:"
    puts "  tail -f ~/Library/Logs/tinybridge.log"
  end

  def post_remove
    puts "Removing LaunchAgent..."
    plist_path = "#{ENV['HOME']}/Library/LaunchAgents/com.tinybridge.daemon.plist"
    system("launchctl unload #{plist_path}") if File.exist?(plist_path)
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridged --version")
  end
end
