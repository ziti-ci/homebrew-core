class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.3.tgz"
  sha256 "c8ae49b3540427f418d00b9f245533e82c845f970eda19acb1c217c93082245c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c6bbb32f5f980765194e2b809d1e7f9635fa21995f5880163893c822e8d9315"
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
