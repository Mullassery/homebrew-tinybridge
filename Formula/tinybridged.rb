# frozen_string_literal: true

class Tinybridged < Formula
  desc "TinyBridge daemon and VM host - Linux environment manager backend"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.5.1/tinybridge-0.5.1-aarch64-apple-darwin.tar.gz"
  sha256 "1b6e12664ca774e77becee9ee7152464ac660e0961ded70e7a25ae50f91e979c"
  license "Proprietary"

  depends_on macos: :ventura
  depends_on "tinybridge"

  disable! date: nil, because: :unsupported unless Hardware::CPU.arm?

  def install
    # tinybridged itself has no dylib dependency and installs normally.
    bin.install "tinybridged"

    # tinybridge-vmhost loads libTinyBridgeVZBridge.dylib via @rpath, but the
    # binary has no embedded rpath and wasn't built with headerpad room to
    # add one via install_name_tool (fails: "load commands do not fit").
    # Wrap it with a DYLD_LIBRARY_PATH env script instead of patching it.
    libexec.install "tinybridge-vmhost", "libTinyBridgeVZBridge.dylib"
    (bin/"tinybridge-vmhost").write_env_script libexec/"tinybridge-vmhost",
                                                DYLD_LIBRARY_PATH: libexec.to_s

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

      A full guest OS boot to a login prompt is not yet verified upstream —
      see the release notes for v0.5.1 ("Honest status" section) before
      relying on this for anything beyond local testing.
    EOS
  end

  test do
    assert_match "tinybridge", shell_output("#{bin}/tinybridged --version")
  end
end
