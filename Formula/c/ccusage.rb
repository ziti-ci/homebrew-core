class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.3.tgz"
  sha256 "b555e5d21d8c6f021cd7925861e30514ec8aa951d0e308e130b6a4c142beb5cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30783f27b57951eaa3bcb49227107e373a58d38a153c28226941781179912674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30783f27b57951eaa3bcb49227107e373a58d38a153c28226941781179912674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30783f27b57951eaa3bcb49227107e373a58d38a153c28226941781179912674"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd9611ad1d36eac5c5fa7755715dc8acb767fb1c3059c228d0dd637935693a1"
    sha256 cellar: :any_skip_relocation, ventura:       "ddd9611ad1d36eac5c5fa7755715dc8acb767fb1c3059c228d0dd637935693a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30783f27b57951eaa3bcb49227107e373a58d38a153c28226941781179912674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30783f27b57951eaa3bcb49227107e373a58d38a153c28226941781179912674"
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
