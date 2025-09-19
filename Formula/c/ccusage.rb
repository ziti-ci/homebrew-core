class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.0.2.tgz"
  sha256 "4d6b810ce15eb4ccfcd1316271f29927dd0007747fc00806e9f7b380e06ecfe7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d71684409bd34d2201f3ad1ac604a147cb32aea91cc1d6ea83d763fba04bf120"
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
