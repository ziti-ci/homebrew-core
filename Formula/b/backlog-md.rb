class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.16.4.tgz"
  sha256 "5b982ab171799f7cb06933103b75fb505291c67b8858b101e7be4941f7d0af78"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1cc18e095e7d2da7aaba411ed95dcf4620ef19b6cf2aa9607b8ad7ad46907060"
    sha256                               arm64_sequoia: "1cc18e095e7d2da7aaba411ed95dcf4620ef19b6cf2aa9607b8ad7ad46907060"
    sha256                               arm64_sonoma:  "1cc18e095e7d2da7aaba411ed95dcf4620ef19b6cf2aa9607b8ad7ad46907060"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b8b8dee69e4f7e4b4af046b40826b8c2cc058fb2a3aaa83bfba120ee09fb795"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4968f5777adfb5698a5adfd0cff997273835d3f1896bdd016af264e40ec669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7383ebd50e07c30d0ec847574c78939e7cda85a68cc3d753843c30d5a0a0a0a3"
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
