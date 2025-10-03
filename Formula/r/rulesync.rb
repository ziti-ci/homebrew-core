class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-2.1.0.tgz"
  sha256 "64012cb247be1dd3ab253d12b82b4a31cc87b1c573092c2e96e67c7c3964984a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1824d91d06a76c139c916764823fd23f4a1695145050240063f564a05fef85f9"
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
