class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.1.0.tgz"
  sha256 "b09599584f415c3063847e1fe70eafa77e29873a700c6d8bdfeca31510165282"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8aefa69addd438c5f1b5d0dc8a79ed7e95402bb052755d58814bfb0d50c7af56"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
