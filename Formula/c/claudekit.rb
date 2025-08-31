class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.9.tgz"
  sha256 "5f8a252dfebb5f529947997361070b7db57b94d10dab5bccd721d0f3329a1b31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcf8150c2ac1c9a58953cd76c23cd30139c6891c0a08e824a349bd4ffeae51ed"
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
