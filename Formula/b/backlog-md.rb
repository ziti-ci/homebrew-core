class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.4.tgz"
  sha256 "71f373c73a1bbd09544a2db2b1eaf5827e68a4410f8969ebc3cbeaa04f66f951"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "fe6193be3d1b05c356a8ef09da85260cc7705b522f5b4d6ddfbd7f63640a1fdf"
    sha256                               arm64_sonoma:  "fe6193be3d1b05c356a8ef09da85260cc7705b522f5b4d6ddfbd7f63640a1fdf"
    sha256                               arm64_ventura: "fe6193be3d1b05c356a8ef09da85260cc7705b522f5b4d6ddfbd7f63640a1fdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e91cb5b7ce2b792b7db7c7d0814510ae750e30f1eb336ff8fde09d2cc9f9347d"
    sha256 cellar: :any_skip_relocation, ventura:       "e91cb5b7ce2b792b7db7c7d0814510ae750e30f1eb336ff8fde09d2cc9f9347d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a13397eed8ee8652ffd1e0c6ba38bda3ffd7c179b7910c1bbbdc00de96cd033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9287225748d3375eda33f285a7cbb590dc5264a2fed1e7c0346a0c73edc0ca09"
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
