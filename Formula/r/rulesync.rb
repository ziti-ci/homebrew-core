class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.67.0.tgz"
  sha256 "571f0eb203d298ba83740c7c664be76d46c78849ebc3a4c343d2dbd9f9b471f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a856aaafbdfa8266981e807080319d23040ca5d856c89b54c997b48c61631429"
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

    output = shell_output("#{bin}/rulesync status")
    assert_match ".rulesync directory: ✅ Found", output
  end
end
