class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.19.4.tgz"
  sha256 "6dd86932478c1671c432bd1771a8fd9dd1213b85938651ad35c6319a2bec356a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89c3de8677dbdd871baec7a0634b9cf31376d9786002dcfee51afd3a6009920a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6725aff04f2ba1851a7a2d84efbef712a5d6d96129a523fbc9748951d5e0093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfe54d8740c60d786e98b0fb2cf1436b1e9a9752e4aa0f3b9947386d1ffc2d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "845f51778fc8531db91fc7b5f4d65150bf706bcb3c559aff4147c596bc098871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6902807ffcc59fecf29a457ff76bd15903a20a24899f178ba3291f4d72882a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6ea99fd0730c7a383689eeeb156bc787db9ea62ccaf5d53e63ae3a2fa3a837"
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
