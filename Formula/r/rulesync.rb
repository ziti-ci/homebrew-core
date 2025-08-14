class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.61.0.tgz"
  sha256 "02334e326217201969f73113a1821b0485f8499d5177db3b36f219cedcbe07f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18145c64b3f2d92df9a89c5304a80a2b0c4db18a28d5a4c2e3b200b8f812cdad"
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
