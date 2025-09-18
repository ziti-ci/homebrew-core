class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.12.3.tgz"
  sha256 "0beb01fd804b25bbf198af3e18e2fa6bd620cff963ab75decbb0e445a0e5c0c9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c619d439288f19acad5b3e35bd4ee0d99970a428dd83f9183db63b8a7b20a9f2"
    sha256                               arm64_sequoia: "c619d439288f19acad5b3e35bd4ee0d99970a428dd83f9183db63b8a7b20a9f2"
    sha256                               arm64_sonoma:  "c619d439288f19acad5b3e35bd4ee0d99970a428dd83f9183db63b8a7b20a9f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "265beec098f5a090900ec76b7d4ea0ebf41091522dd7057d20e20b5b709348cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dbc55e9b79a65396180b3bb43e0ea2e471d364ee16b1f7869cfcc53e2e9d54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe80fa709190baae26668e3af3e18dea5da90ba87cb24c20f04ca2399a0ffaab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
