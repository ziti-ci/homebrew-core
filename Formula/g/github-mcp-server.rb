class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "a5e2f13cbf2223c6c2e0bce6d842f9f05aa1f8c291c0518fca8066d10a5c25a6"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28fa587229c9bbe08198cdd56bf0574fa58745fab3023f816d78602b2ff0ce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28fa587229c9bbe08198cdd56bf0574fa58745fab3023f816d78602b2ff0ce8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b28fa587229c9bbe08198cdd56bf0574fa58745fab3023f816d78602b2ff0ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "715834e0d483637f1115b924dbad9119c90f96be71e7304358133c5ab106efe7"
    sha256 cellar: :any_skip_relocation, ventura:       "715834e0d483637f1115b924dbad9119c90f96be71e7304358133c5ab106efe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e071594efd94954d45817194cc6f1e50fe1a2dc233541123c0d93fc5766f6c13"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "tools/call"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output(bin/"github-mcp-server stdio 2>&1", json, 0)
  end
end
