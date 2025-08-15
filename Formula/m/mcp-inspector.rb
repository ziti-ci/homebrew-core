class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.4.tgz"
  sha256 "a0e2c00e26e520fbbadf135ecf9b5808d86a7361375f3088d258df0e497e73cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df4339b20c39dbab39fa73a52515dd0638aff5c2c48f35ba4b90b1fdcc54c352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df4339b20c39dbab39fa73a52515dd0638aff5c2c48f35ba4b90b1fdcc54c352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df4339b20c39dbab39fa73a52515dd0638aff5c2c48f35ba4b90b1fdcc54c352"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dbdc6e5e3231eb4573f77f034343e0aa54e94e8f96dd3d9aa12ca30edf555bc"
    sha256 cellar: :any_skip_relocation, ventura:       "9dbdc6e5e3231eb4573f77f034343e0aa54e94e8f96dd3d9aa12ca30edf555bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4339b20c39dbab39fa73a52515dd0638aff5c2c48f35ba4b90b1fdcc54c352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df4339b20c39dbab39fa73a52515dd0638aff5c2c48f35ba4b90b1fdcc54c352"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
