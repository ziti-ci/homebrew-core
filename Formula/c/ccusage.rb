class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.5.0.tgz"
  sha256 "a5bd1d97160e4a7a8991992700aa3378e7411f7ada54ea2a1ca1969115ff2e2a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output(bin/"ccusage 2>&1", 1)
  end
end
