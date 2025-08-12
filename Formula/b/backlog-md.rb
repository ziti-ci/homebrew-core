class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.8.2.tgz"
  sha256 "60ed0319797853d910dc3f23b70e021285d3106d9a07892abf3d08be482c1f5e"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "5b269a6afc4443e11dc0fd337e229f11ae806eefb560ef51ea7b79e65ed9eb7a"
    sha256                               arm64_sonoma:  "5b269a6afc4443e11dc0fd337e229f11ae806eefb560ef51ea7b79e65ed9eb7a"
    sha256                               arm64_ventura: "5b269a6afc4443e11dc0fd337e229f11ae806eefb560ef51ea7b79e65ed9eb7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d01f03a36dbed723eeac0def9b5a10668f3c17d9d77954058e5f5dc29ce9b04"
    sha256 cellar: :any_skip_relocation, ventura:       "4d01f03a36dbed723eeac0def9b5a10668f3c17d9d77954058e5f5dc29ce9b04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26c338eb641c16738b3040bd5834f4607e29d32b3c3f97d7d32321db01991927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd2f499fa0da9423b9a5373557ea60ad70873b75b68cb9fadd7a3b7f5085bd8b"
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
