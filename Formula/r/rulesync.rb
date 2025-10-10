class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.4.2.tgz"
  sha256 "40deff6aa660215d3215863466482f8685722ef878b66afe0393fc2a84e7bd95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30807fcf358d8e7ddde847e28661641db2723cfce1dd5103dfaf2b47e1bebd7f"
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
