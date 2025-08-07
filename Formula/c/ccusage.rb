class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.8.0.tgz"
  sha256 "c02904fedd3a769c3bdf6a19275345eaed40b33d8871676caa2020af5d44211e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f502aa09a2cb711750168130a44fedb3bb64687df98fce8ed1d91730ed522a1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f502aa09a2cb711750168130a44fedb3bb64687df98fce8ed1d91730ed522a1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f502aa09a2cb711750168130a44fedb3bb64687df98fce8ed1d91730ed522a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6fadd7b1d9cb63175029f3c6df65dcb3ba3fb0a7aba871e9880441cc6c92be"
    sha256 cellar: :any_skip_relocation, ventura:       "bd6fadd7b1d9cb63175029f3c6df65dcb3ba3fb0a7aba871e9880441cc6c92be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f502aa09a2cb711750168130a44fedb3bb64687df98fce8ed1d91730ed522a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f502aa09a2cb711750168130a44fedb3bb64687df98fce8ed1d91730ed522a1f"
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
