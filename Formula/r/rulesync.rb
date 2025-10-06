class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.1.1.tgz"
  sha256 "faffd71c7953149672f291cef181a85c9aca6410b17788c0c937f625cb8d290f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "210565eecb6d408ca65371f554abf2a29c6669becbdf19fb0b725ff663eb42da"
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
