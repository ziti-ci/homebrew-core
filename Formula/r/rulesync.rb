class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.60.0.tgz"
  sha256 "cf2f8cf1800ac94ab0ed071334047b44a29e7d1e5f1f6ee8c3c0ebfb976d9dc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1f36b8947207aefb22fcd5efcde42f4cb25662a6e688b85ab072ce2d593b5ff"
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
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/overview.md").read

    output = shell_output("#{bin}/rulesync status")
    assert_match ".rulesync directory: ✅ Found", output
  end
end
