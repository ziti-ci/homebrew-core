class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.5.tgz"
  sha256 "4bec9caf4c7b484d9663f68ee86ada45bc167044485aedc067c89af95d2e8494"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1de650deda69424a92aec1a00d4627930e1692b575c7970a244e5754acf998e9"
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
