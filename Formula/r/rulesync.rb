class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.2.3.tgz"
  sha256 "a3da60a95547d5fc60f1a676ad42e5a4f59025e92ed52f296e6d6d9ddc15e20d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e8487b549af7f11c75e49314669415ad81ba40e31db2785c55cdddac4871ac5"
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
