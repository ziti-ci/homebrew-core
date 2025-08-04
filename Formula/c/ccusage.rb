class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.7.0.tgz"
  sha256 "519d406e64ffe0059e56c86da48bf9c3fdc1c5d7a57e631390d8715a83f93657"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a7d4df5b41d3936bb39bd3706addcd11abfa804b021168a03b7a37e7b3d8a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24a7d4df5b41d3936bb39bd3706addcd11abfa804b021168a03b7a37e7b3d8a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24a7d4df5b41d3936bb39bd3706addcd11abfa804b021168a03b7a37e7b3d8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5b6cc58619eaa3c331d90d9ee3902ea104b6bc49698e7f7ef53a693438f65c6"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b6cc58619eaa3c331d90d9ee3902ea104b6bc49698e7f7ef53a693438f65c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a7d4df5b41d3936bb39bd3706addcd11abfa804b021168a03b7a37e7b3d8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a7d4df5b41d3936bb39bd3706addcd11abfa804b021168a03b7a37e7b3d8a1"
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
