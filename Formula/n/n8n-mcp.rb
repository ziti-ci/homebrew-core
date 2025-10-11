class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.10.tgz"
  sha256 "294c308508881288810fac6b28504bf392bc28d641f5a33e068608a688cd0995"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9a5d86be826862a96c4c68002d1dc75d4cb6c67b19d6afd1af1c2269f130ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d8a0af2403ad0bb0fac9544e6db44410714141c283972c4d88407486edc3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9c524b6c6026ac97913afe8c65233959f0a3c1ae91703654e3b3c35b574157f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea9d7da6d4e0c28ccf5120c3dbd28c68e544ed4d5f6c485f2a39098ecb0e58cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "937ebb298a12779edbe61cd19c1fbe9b2ec9b5fd767e8cddf13e2894b6542828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e2e770b359738045bf49618fde86a595467d9a4925009dff8dfd915c410401"
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
