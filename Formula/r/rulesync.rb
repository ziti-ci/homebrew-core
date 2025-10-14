class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.4.3.tgz"
  sha256 "33eba00a3f0f6f44af6d9023e5e9f42dacd671b760fa899efaf6626326942505"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab1f45609040c0d99c215f6efbc2ae34162390a6d16826725f7c51225f2a5552"
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
