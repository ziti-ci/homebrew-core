class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.10.tgz"
  sha256 "bc9e5bbf4c5dbebff18f75e358bf5f31c72063c4f26d6cef54b6ae7133630715"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "453143bbac3c93fa2c4a0f686c844bc27df8e63847c2eb072853ee44e98ee748"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudekit --version")
    assert_match "Hooks:", shell_output("#{bin}/claudekit list")
    assert_match ".claudekit/config.json not found", shell_output("#{bin}/claudekit doctor 2>&1", 1)
  end
end
