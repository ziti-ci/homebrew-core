class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.8.tgz"
  sha256 "8cf2e3b0f8fe445a8bbcc8e9500cf05259c48226159769286b45723857d44f88"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "426fcca493e4a0a68dc8033de3698e6636c486f1bf38e1f722d9007ad8119a80"
    sha256                               arm64_sonoma:  "426fcca493e4a0a68dc8033de3698e6636c486f1bf38e1f722d9007ad8119a80"
    sha256                               arm64_ventura: "426fcca493e4a0a68dc8033de3698e6636c486f1bf38e1f722d9007ad8119a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "a200e90b6282b00395937a5bf1c3b4e234606ed50eb823a3bb8d0cb44f41c997"
    sha256 cellar: :any_skip_relocation, ventura:       "a200e90b6282b00395937a5bf1c3b4e234606ed50eb823a3bb8d0cb44f41c997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66a3b2b903bb010a1a674b5ec3e0efd33d1bef1739d0dd9393e49d80f08d14fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582f0ec7eb8c681cb28a753544d03a66e27dee9125b4a43a8d95c0850067cbf8"
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
