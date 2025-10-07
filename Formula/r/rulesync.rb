class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.3.0.tgz"
  sha256 "3f131ba749fc1f2459cb11a9054831bcc97d0ac86e1c05d1207630f485d9e422"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35b6ed95d808ee92b74c7b691bf6c378192ffb4b76f4676dfdcfa54042215e5e"
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
