class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.9.tgz"
  sha256 "989dc4e74437d20fdc43db1b80975980404d2098d021263a2f8a7cd3b29b34de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3541a684b0823b7639b7c789302f376cb9e147c6f84ecafe057c0a7cfd4887c0"
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
