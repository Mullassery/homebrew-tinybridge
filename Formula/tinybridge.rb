# frozen_string_literal: true

class Tinybridge < Formula
  desc "Run Linux environments on macOS with zero configuration"
  homepage "https://github.com/Mullassery/tinybridge"

  on_macos do
    on_arm do
      url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.1/tinybridge-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "13ee70f0ae8b7dd11fd22ca8cfc226293c4d35d6ae7de680e65356b32e54123d"
    end
    on_intel do
      url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.1/tinybridge-0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "13ee70f0ae8b7dd11fd22ca8cfc226293c4d35d6ae7de680e65356b32e54123d"
    end
  end

  license "Proprietary"

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
