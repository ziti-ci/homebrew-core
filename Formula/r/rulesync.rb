class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.3.1.tgz"
  sha256 "1ae62843b447e33712abc679607a3995d98978529bcf94d57bd704b766c68f8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71cf9c4c33ce388a275ebe3f6497a4c0936cf41c69461b4706b6db2b3dc31620"
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
