class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.6.tgz"
  sha256 "aa8d6b5a1906e64b5e145765b7bc43e9c601564fd4f1a9a93d294797d8ceef7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d721bce81fc36f950e018788bbbfc78cc0a3b362f53c3f0b41ef0978218cb3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1c7e741b601998ed00284179b800063cf2d0dea578b6240aca38814d63d4f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df05dd703e3900aa7a13e39a1b63a8b38fb41adadea062fd995d40348ed428a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc3f773efe3b67b2be154b239e628dc49f8fe6062069368fd9e5c205e01e0b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048f11aff0b01c6ceae5b5b05131f0b69a2850027245527ddaf94b9fa717ed93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab30e8199bb3af646080cc34399e42f83eacd6326119cb2765de0777604a1e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 10
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
