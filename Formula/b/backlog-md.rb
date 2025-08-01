class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.6.tgz"
  sha256 "f09a813aab773ffd0af9eaecdea3273344be657076f59d876ee7f14ab86a1181"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ac559a3d40d92ef49d757ed69779fe3ffc669b7c45b74acc41229b4267275671"
    sha256                               arm64_sonoma:  "ac559a3d40d92ef49d757ed69779fe3ffc669b7c45b74acc41229b4267275671"
    sha256                               arm64_ventura: "ac559a3d40d92ef49d757ed69779fe3ffc669b7c45b74acc41229b4267275671"
    sha256 cellar: :any_skip_relocation, sonoma:        "7da49dfa50ab396d6dcbba11f3678b1fedaa40bcc5367fcd5719e958dff7602e"
    sha256 cellar: :any_skip_relocation, ventura:       "7da49dfa50ab396d6dcbba11f3678b1fedaa40bcc5367fcd5719e958dff7602e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b5446e36e45196641dc1aa19664ddfd7293373b8b385abc30a2bbd2f13a4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369c718bcebaee1bccd96aa92d869fdb5d1c40990807b4b122832e639fe274f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    port = free_port
    pid = fork do
      exec bin/"backlog", "browser", "--no-open", "--port", port.to_s
    end
    sleep 2
    assert_match "<title>Backlog.md - Task Management</title>", shell_output("curl -s http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
