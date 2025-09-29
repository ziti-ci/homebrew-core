class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.0.tgz"
  sha256 "b07c577e81ad0a24622625e66749228a2189b0e13a163b6628a8329c76525570"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c407827a2187467d3fa66655534f896803ac3b58aea2b203fc97210b39dff872"
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
