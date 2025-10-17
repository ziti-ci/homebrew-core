class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.6.0.tgz"
  sha256 "95e0cf10428b35323498401d24b27b3586f52cc438e17e9bc2396a70206ea37b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b69af08adde7c29e88ddfad9e333cc53e17ba5ed38eaf4f564dfee126529de2"
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
