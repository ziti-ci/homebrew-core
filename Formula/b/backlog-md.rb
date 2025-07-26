class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.0.tgz"
  sha256 "c694170b6c60c962f2517bf655169245f83175ed6f1ef9b4172fa81bc2600ed3"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "e072f5f0a7e32d47529a0f31bad875bd91b68bc8a582818a9b02871c2bdd5d34"
    sha256                               arm64_sonoma:  "e072f5f0a7e32d47529a0f31bad875bd91b68bc8a582818a9b02871c2bdd5d34"
    sha256                               arm64_ventura: "e072f5f0a7e32d47529a0f31bad875bd91b68bc8a582818a9b02871c2bdd5d34"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a464ca990029af0e6ee571066302f3c15d4d5116bb1dd50f0bc9748810d2ad8"
    sha256 cellar: :any_skip_relocation, ventura:       "4a464ca990029af0e6ee571066302f3c15d4d5116bb1dd50f0bc9748810d2ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85984bfb7ab5ba0d59ae27ace5e934ec5a979f81b34f3ca73dda0f7e983d46f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d59d5f9b741039c95c8ff0a739c5a408b344f23fec906043e3a200e954d5458"
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
