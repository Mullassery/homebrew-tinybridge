# frozen_string_literal: true

class Tinybridged < Formula
  desc "TinyBridge daemon - Linux environment manager backend"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.0/tinybridged-0.3.0-x86_64-apple-darwin.tar.gz"
  sha256 "TODO_REPLACE_WITH_ACTUAL_SHA256"
  license "Proprietary"

  def install
    bin.install "tinybridged"
  end

  def post_install
    puts "✅ TinyBridge daemon installed!"
    puts ""
    puts "Configuring daemon auto-start..."

    # Create LaunchDaemons directory if needed
    system("mkdir -p #{ENV['HOME']}/Library/LaunchDaemons")

    # Create LaunchAgent plist
    plist_path = "#{ENV['HOME']}/Library/LaunchDaemons/com.tinybridge.daemon.plist"
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
              <string>--socket</string>
              <string>/tmp/tinybridge.sock</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
              <key>SuccessfulExit</key>
              <false/>
          </dict>
          <key>StandardErrorPath</key>
          <string>/var/log/tinybridge.log</string>
          <key>StandardOutPath</key>
          <string>/var/log/tinybridge.log</string>
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
    puts "Daemon is now running in the background!"
    puts ""
    puts "View daemon logs:"
    puts "  tail -f /var/log/tinybridge.log"
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridged --version")
  end
end
