class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "fe471aa9fd8a45db2ae2b619b9ef4f7bd8ee9a3193f2f52b11808c1374cc71f8"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67a52e0cb2d805d7f453f5ab3d7c248e2d4dc8a679627268a53b0933b65f06c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61ab3a93107d249a29b15ba81df5f641b69e64f209e39fcd479b5ed1d5fda01e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a09c7802bf7dcc75f176e89c16027f09ad6f309f8cca5c8c486c8fca0a9766d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a55baf941aab2abe82bf8679cc139146b0e32007bae612362da1d1596e540ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d327ea1cee5b082ee9f45b4b0d681ed144e5cfab5b0a7cb201b10999761e007f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
