# frozen_string_literal: true

class Tinybridge < Formula
  desc "Run Linux environments on macOS with zero configuration"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.5.1/tinybridge-0.5.1-aarch64-apple-darwin.tar.gz"
  sha256 "1b6e12664ca774e77becee9ee7152464ac660e0961ded70e7a25ae50f91e979c"
  license "Proprietary"

  depends_on macos: :ventura

  # Only an Apple Silicon (arm64) build is published as of v0.5.1 — no
  # Intel (x86_64) release artifact currently exists.
  disable! date: nil, because: :unsupported unless Hardware::CPU.arm?

  def install
    bin.install "tinybridge"
  end

  def caveats
    <<~EOS
      This installs the CLI only. For the background daemon (required for
      most workflows) and the per-VM host process, install `tinybridged`:
        brew install tinybridged

      A full guest OS boot to a login prompt is not yet verified upstream —
      see the release notes for v0.5.1 ("Honest status" section).
    EOS
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridge --version")
  end
end
