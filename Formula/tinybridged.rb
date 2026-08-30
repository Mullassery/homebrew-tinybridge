# frozen_string_literal: true

class Tinybridged < Formula
  desc "TinyBridge daemon and VM host - Linux environment manager backend"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.6.0/tinybridge-0.6.0-aarch64-apple-darwin.tar.gz"
  sha256 "fdf796c5cf81a29d19db0e1ddbe04f7a1594e2cfdadc601309357789af4fc40c"
  license "Proprietary"

  depends_on macos: :ventura
  depends_on "tinybridge"

  disable! date: nil, because: :unsupported unless Hardware::CPU.arm?

  def install
    # tinybridged itself has no dylib dependency and installs normally.
    bin.install "tinybridged"

    # As of v0.6.0, tinybridge-vmhost is built with an @executable_path
    # rpath (crates/tinybridge-vmhost/build.rs upstream), so it finds
    # libTinyBridgeVZBridge.dylib next to itself with no DYLD_LIBRARY_PATH
    # wrapper or install_name_tool patch needed — just keep them together.
    libexec.install "tinybridge-vmhost", "libTinyBridgeVZBridge.dylib"
    bin.install_symlink libexec/"tinybridge-vmhost"

    # tinybridge-vmhost requires the com.apple.security.virtualization
    # entitlement to call into Virtualization.framework. Ad-hoc signing
    # satisfies this for local use (no paid Apple Developer account needed).
    entitlements = buildpath/"tinybridge-vmhost.entitlements"
    system "codesign", "--force", "--sign", "-",
           "--entitlements", entitlements.to_s,
           libexec/"tinybridge-vmhost"
  end

  service do
    run [opt_bin/"tinybridged"]
    keep_alive successful_exit: false
    log_path var/"log/tinybridge.log"
    error_log_path var/"log/tinybridge.log"
  end

  def caveats
    <<~EOS
      The daemon is installed but not started automatically. To start it now
      and on every login:
        brew services start tinybridged

      Logs: #{var}/log/tinybridge.log

      Guest boot to a real login prompt is verified working upstream as of
      v0.6.0, but this install path doesn't bundle or auto-download a root
      filesystem image yet, so you'll need to supply your own kernel/disk/
      seed image. See the main repo's README "Honest status" section for
      the current, accurate picture before relying on this for anything
      beyond local testing of the CLI/daemon/VM-host plumbing itself.
    EOS
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridged --version")
  end
end
