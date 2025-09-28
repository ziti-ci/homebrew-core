class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.9.4.tgz"
  sha256 "b6b8887e129ac42773d2e6884e39300bcf44b7e24bdb5124d3c809fd9bde4d94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b559a41970b4135a6a53da230bd16773b5eb4b83e77d9243e4cd3f1c21b7d455"
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
