class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "74fe14fbe3edc7ac98dfc59a10d92d66829cf37c8c7aeb09e96dad4ab5c0c772"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b36fb68a250b410cc154203e8a0771798d62d80bef0080ec226c5e10565fc5d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b5c71536c37d0a1c89cce44ec4d0df186dd72f9870cb5d3296f745a28776fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e569db987d09adb8c7ebce9c7d23ee69ffeb10669952558567044e191b02f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "558f38ddf73e6f60dc6c623390c24c56b565c6a1038ee499a1bd77976eb9fc21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14c87155cc561262030da6ab9d4b8546ab49ea3249754685daa0294ee2868988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98e055cf0d0ed95355bb0c3b15c0a7809aad5dc729cc9c18aae387e0d5be53a"
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
