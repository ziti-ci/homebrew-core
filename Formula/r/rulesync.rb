class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-2.2.0.tgz"
  sha256 "4cdd67784c5db79046f63336277a864b4736723ffe57f9cdb55988b52637dcfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08240a12239474ed450c6bd447de4746583eca098fa32e314bdcc0d6ab0696f7"
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
