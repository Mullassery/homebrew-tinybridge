# frozen_string_literal: true

class TinybridgeApp < Formula
  desc "TinyBridge menu bar app - visual environment manager"
  homepage "https://github.com/Mullassery/tinybridge"
  url "https://github.com/Mullassery/tinybridge/releases/download/v0.3.0/TinyBridge-0.3.0.dmg"
  sha256 "TODO_REPLACE_WITH_ACTUAL_SHA256"
  license "Proprietary"

  app "TinyBridge.app"

  depends_on macos: ">= :ventura"
  depends_on formula: "tinybridge"
  depends_on formula: "tinybridged"

  def post_install
    puts "✅ TinyBridge menu bar app installed!"
    puts ""
    puts "Features:"
    puts "  • Real-time environment status"
    puts "  • One-click launch/stop"
    puts "  • Built-in onboarding wizard"
    puts "  • Native notifications"
    puts ""
    puts "To launch:"
    puts "  1. Open Applications folder"
    puts "  2. Find 'TinyBridge'"
    puts "  3. Click to open"
    puts "  4. Menu bar icon appears at top right"
  end

  test do
    assert_predicate appdir/"TinyBridge.app", :exist?
  end
end
