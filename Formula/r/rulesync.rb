class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.0.1.tgz"
  sha256 "2c4775e5483cb352cc6ec06c244fa239c4f87ce0703d0e34e12e4a582d481d8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18814bd31ce8f4eea82eb7d81031c5f4cbcedbd2285b6cbfe3edc5a58b8a9bf6"
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
