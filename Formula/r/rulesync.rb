class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.76.0.tgz"
  sha256 "b0961504e7e4d5064a23682a3d51bf2c6615f8c675a73a516ed2d2fc7e425472"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e935fe4d35e09ad5eb757cf913cc6cfd2cac10163e6ae51f00a3d7dee04728c6"
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
