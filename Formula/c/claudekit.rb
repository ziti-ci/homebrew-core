class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.9.3.tgz"
  sha256 "f3c86834e0c191848c6ef598200ad891c6f13b7232235666b12c5261ec376939"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db921bf94e30337fced47b7eb63a5e683a11affca7ca1ee5973366051a7b362a"
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
