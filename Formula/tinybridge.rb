# frozen_string_literal: true

class Tinybridge < Formula
  desc "Run Linux environments on macOS with zero configuration"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.6.0/tinybridge-0.6.0-aarch64-apple-darwin.tar.gz"
  sha256 "fdf796c5cf81a29d19db0e1ddbe04f7a1594e2cfdadc601309357789af4fc40c"
  license "Proprietary"

  depends_on macos: :ventura

  # Only an Apple Silicon (arm64) build is published as of v0.6.0 — no
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

      Guest boot to a real login prompt is verified working upstream as of
      v0.6.0 (see the release notes' "What's new" section) — but this
      install path doesn't bundle or auto-download a root filesystem image
      yet, so you'll need to supply your own kernel/disk/seed image. See
      the main repo's README "Honest status" section for the current,
      accurate picture.
    EOS
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridge --version")
  end
end
