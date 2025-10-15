class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "73c0732d8c438101739493030e795ac88b100517c4c804d2e473f8672cda25bf"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84d8aafc3e66c00f6b32eae26a36dcbdf6ac6175aff01f460b6df55590062463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a608559517117aecd10319eeebcb02b9cd183dcd15e66d19790f9d618cbb1ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c6032883a7356fe35376c8709efb13489aab2704aa3dd55a3f7beabfe4122b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ed294ea163dd2b2b52561334b13331e9658eb94dead0c72ace7357a5ff6c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73476d2103095c91bd3a208f1557d075558177415c2fb8fd4554cb1c88f18ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7084e0c9a8b6a3d1e97025bb674eca0c8707a4d97381bcd46b9de42f5aae2111"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
