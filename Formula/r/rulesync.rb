class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-2.0.0.tgz"
  sha256 "59f325052b837aecdf10741cf5f3b55e54465ac2c186e60dccb3454dbd5e27a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1b065de45ed2d5b88f666ec0408b7b82d2aecfea70e8130628e010063c4df3e"
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
