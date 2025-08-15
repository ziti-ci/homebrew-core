class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.6.tgz"
  sha256 "bc573b6a0f8565e8b918ff05bf4f1cbc4fb1b2df310553c3df6c550fc5decb24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3cfb442f2e2c567e8868764c0b130efc6b35c44ce6a8baedac5734ffcaa3461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3cfb442f2e2c567e8868764c0b130efc6b35c44ce6a8baedac5734ffcaa3461"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3cfb442f2e2c567e8868764c0b130efc6b35c44ce6a8baedac5734ffcaa3461"
    sha256 cellar: :any_skip_relocation, sonoma:        "5337c3f2e0327edc97385ab02df7df7e377a54df6a6ead6fb3b64916c3cc04a2"
    sha256 cellar: :any_skip_relocation, ventura:       "5337c3f2e0327edc97385ab02df7df7e377a54df6a6ead6fb3b64916c3cc04a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3cfb442f2e2c567e8868764c0b130efc6b35c44ce6a8baedac5734ffcaa3461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3cfb442f2e2c567e8868764c0b130efc6b35c44ce6a8baedac5734ffcaa3461"
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
