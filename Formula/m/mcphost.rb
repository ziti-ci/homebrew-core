class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "8bb1a75f8b29f414735c52a64d0a9d8b0f114f99d9a2803d7dff62fe4fb2091f"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6734a419e180d73b5b8e9c36f0972b9d47e4b15b401086c2abc38049f7b4519f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6734a419e180d73b5b8e9c36f0972b9d47e4b15b401086c2abc38049f7b4519f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6734a419e180d73b5b8e9c36f0972b9d47e4b15b401086c2abc38049f7b4519f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3de4d2e87da73c0b3845ebef10170482a05fc06d78de86c5dfe330575fa0c90"
    sha256 cellar: :any_skip_relocation, ventura:       "d3de4d2e87da73c0b3845ebef10170482a05fc06d78de86c5dfe330575fa0c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba0d092c9903b1df803e97a6548b707a49721f764db3ed938bcddaf9184637f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
