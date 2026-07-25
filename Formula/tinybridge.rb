# frozen_string_literal: true

class Tinybridge < Formula
  desc "Run Linux environments on macOS with zero configuration"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.4.0/tinybridge-0.4.0-x86_64-apple-darwin.tar.gz"
  sha256 "TODO_REPLACE_WITH_ACTUAL_SHA256"
  license "Apache-2.0"

  depends_on "tinybridged" => :run

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
