class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-16.2.5.tgz"
  sha256 "19795e0696775c5e035ab5c6df52a1d794a838b466ea45eebaf204104990f1e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b71b786d4957004621b4b0f9a07f189797a4793736bac9b4ef0333c8210bbc23"
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
