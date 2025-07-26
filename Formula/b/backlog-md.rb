class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.10.tgz"
  sha256 "8a557ea216790aa3c861f79b184e8a2a6690f95c9f1c2938035452de65a16922"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "285c259353db8c0164de8ac6c7b99f1bceab0edddd7b07d467ba680b2d594fbb"
    sha256                               arm64_sonoma:  "285c259353db8c0164de8ac6c7b99f1bceab0edddd7b07d467ba680b2d594fbb"
    sha256                               arm64_ventura: "285c259353db8c0164de8ac6c7b99f1bceab0edddd7b07d467ba680b2d594fbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9999e909ae4fc229e8afdb269988659612020c0752e8e541559387ae7223f4f6"
    sha256 cellar: :any_skip_relocation, ventura:       "9999e909ae4fc229e8afdb269988659612020c0752e8e541559387ae7223f4f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "929a0441962966bcb6ad8e3db731d67b98aa01177aa1ff2946ffa45ecbce855b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adfcae67898946444d011f6ef7b08d40f0577c56fc3c48cdc0e618c9e8b62797"
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
