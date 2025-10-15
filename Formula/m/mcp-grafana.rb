class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "b27cd495b55a0ab3c7fea613ed61c2ae2c497f08ee57d90b5fc36844bd0ef617"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3c6f12ab5015cd7df0490aa85a0aa9aff455a1c1a49311fa8d87abe3a249576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed2050570ef0162dcdef73c9af4b6d26bce2098b44c8d51d09b5ae8449c8bb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e6e017958f09a210df94bacb93e34712aa896a4afcf5de5b1a21a0d78209160"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c3355d1082906ea3367e6edc2c16eef45150378b4b5e3bfcf26cbd6205caee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "594946166b1f31240267158c3fd622a5512cf97cd22c1208c9a5b55e0b03283d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22eb32f31619533c56f2292faf3dedf5d47ea9c6257996645b0c0baec70840f8"
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
