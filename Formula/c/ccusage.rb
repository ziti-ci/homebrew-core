class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.1.tgz"
  sha256 "8b28fa8cee4585b83fb30c2b07ced3b9fa7b74141d47390567f80c665c26c276"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6a8d0ae161ad3aabd41c8556fca4e747f2232b222952e4c8e9e020f204133b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
