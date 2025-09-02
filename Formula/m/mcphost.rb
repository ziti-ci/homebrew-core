class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "895bb5a29ce9e9a850491e7e1af6eecdce7540466ed557210ba4b5832cb71cc4"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5225b4a99bf242ce513a4e0014f27bddfa0ec167c5436acb62788c73d1491094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5225b4a99bf242ce513a4e0014f27bddfa0ec167c5436acb62788c73d1491094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5225b4a99bf242ce513a4e0014f27bddfa0ec167c5436acb62788c73d1491094"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9df69a0f4d5d5a48c767a626845f7c989d9833f7a271fc4a6983cb58f0907a1"
    sha256 cellar: :any_skip_relocation, ventura:       "a9df69a0f4d5d5a48c767a626845f7c989d9833f7a271fc4a6983cb58f0907a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f139b7dbbcbebc307b9d60dafcb7b768e9d74dff5524072bc9f01eaadce5baa3"
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
