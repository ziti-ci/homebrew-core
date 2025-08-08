class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.56.0.tgz"
  sha256 "fb5a852bfcb2d0ae8b8cef748729c3a500c34ec5e135755115ca094dbd64f013"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f08c4cbe97ba8772263fd78b4f91463c82bf1656668a3fff07419d423c800b2f"
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
