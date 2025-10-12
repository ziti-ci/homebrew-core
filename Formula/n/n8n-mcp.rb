class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.19.0.tgz"
  sha256 "b326885e5f36c96f13243505887a7154e4a21b4b406a8cfbbfed700fc2a3be0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "190ce448f4924f6daa846e8ba778aa293e5f57cae4bb374e9f2092742b15cdd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53057e09b9aa3a4400bb38f887c4756115143aec3115fa7f15209bfb3ab08374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90020cbdf9f0122ec5560dfeb839b0a81f3292f45ee5006a7553af43386c470"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a1c49599d2aba3bcfcde17348357820e0eb3852b0bfe070180dd21b21b1bc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8607d77d2653784b887cb28a3a1e9508cb5747da597344d4d7cefb4f85c880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68613b4e1266e9f8d3f2f85b1ba8d5d221a09ebe8214a5bd9a780944b088876"
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
