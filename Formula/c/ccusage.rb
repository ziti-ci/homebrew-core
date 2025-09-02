class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-16.2.3.tgz"
  sha256 "0df108c3083ca9f6c9ca229ba73d2b1e04ce68e07918b61f855acae095934718"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09f86eb44defd912308dd674e728fff83984d117e5fb2b03684949bbe7081b9c"
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
