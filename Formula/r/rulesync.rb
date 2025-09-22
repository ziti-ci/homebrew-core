class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.2.2.tgz"
  sha256 "9578e82e5c20cba1b71b822ca93152e15d74dd291577c5eb6a6d257ef2410416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f3cde6a5690d74756c330144a0a556581ac001e711e5193926640f924a433dc"
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
