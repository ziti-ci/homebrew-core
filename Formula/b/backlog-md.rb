class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.0.tgz"
  sha256 "c694170b6c60c962f2517bf655169245f83175ed6f1ef9b4172fa81bc2600ed3"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "23788130952bd29d8b9768e96e4da6fed558185077e26ae70019d5fe818e88a1"
    sha256                               arm64_sonoma:  "23788130952bd29d8b9768e96e4da6fed558185077e26ae70019d5fe818e88a1"
    sha256                               arm64_ventura: "23788130952bd29d8b9768e96e4da6fed558185077e26ae70019d5fe818e88a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb96b29866b3d20385c5dd217ea604a607d5cc942d5f60a628328020f9f15e4"
    sha256 cellar: :any_skip_relocation, ventura:       "0eb96b29866b3d20385c5dd217ea604a607d5cc942d5f60a628328020f9f15e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad0653b1af96fa03acff1c0cc1776ee72dc06e441c3933d39439e20da053cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62beb0a6de711c61b56f426361c1a8c91f28ccaccd0e84c9a13d945d82b1ebfc"
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
