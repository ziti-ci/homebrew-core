class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.11.tgz"
  sha256 "73142db08778bf4aef64c61db20676af3b7916492895e739cb25a12784a3857c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2bc30d53bffa826d723d1ad717295984d14e2efc76c9a4d2e6f6f6af33703fbd"
    sha256                               arm64_sequoia: "2bc30d53bffa826d723d1ad717295984d14e2efc76c9a4d2e6f6f6af33703fbd"
    sha256                               arm64_sonoma:  "2bc30d53bffa826d723d1ad717295984d14e2efc76c9a4d2e6f6f6af33703fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdbacb0d0b8fefc5cc6ae51ac8e961e4f5ad860886ab676f4d22cdaecac3943e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4a1c9dab4f48f9909acbdb9940098c301fe47c59e153f3b200dcd97a17930f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
