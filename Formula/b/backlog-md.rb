class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.7.0.tgz"
  sha256 "2d778b3752f7ae9574ad95fb10e29d70666dd20e0b143dc4a27d6528ded8a1d3"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "8e02dcd25f19996a19f6b4f6f227064e7140414d9d24fa36bbcdfe7c96e9fc94"
    sha256                               arm64_sonoma:  "8e02dcd25f19996a19f6b4f6f227064e7140414d9d24fa36bbcdfe7c96e9fc94"
    sha256                               arm64_ventura: "8e02dcd25f19996a19f6b4f6f227064e7140414d9d24fa36bbcdfe7c96e9fc94"
    sha256 cellar: :any_skip_relocation, sonoma:        "3afa3c952361ec9a47dd41f93d1324fda7d077454a86396b78aa6d8fde418d5e"
    sha256 cellar: :any_skip_relocation, ventura:       "3afa3c952361ec9a47dd41f93d1324fda7d077454a86396b78aa6d8fde418d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "839e1866bf7ce426d2194c29c1fd000268b38a1914f6d6d19e4339628bb765cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b8cb13a3f7ffeb70bd0f3f0a0483b78310db6e52b1206d63a8953973232694"
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
