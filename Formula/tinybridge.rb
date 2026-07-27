# frozen_string_literal: true

class Tinybridge < Formula
  desc "Run Linux environments on macOS with zero configuration"
  homepage "https://github.com/Mullassery/tinybridge"

  on_macos do
    on_arm do
      url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.0/tinybridge-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "c0efc69070a12bba9fa972abf833dc5be09b765848ac62b6cbaad8d3f73f3f74"
    end
    on_intel do
      url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.0/tinybridge-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "c0efc69070a12bba9fa972abf833dc5be09b765848ac62b6cbaad8d3f73f3f74"
    end
  end

  license "Apache-2.0"

  def install
    bin.install "tinybridge"
  end

  def post_install
    puts "✅ TinyBridge CLI installed successfully!"
    puts ""
    puts "Next steps:"
    puts "  1. Install daemon: brew install tinybridged"
    puts "  2. Start your first environment: tinybridge up myproject"
    puts "  3. Enter the environment: tinybridge shell myproject"
    puts ""
    puts "Learn more: tinybridge --help"
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridge --version")
  end
end
