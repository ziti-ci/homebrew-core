class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.17.1.tgz"
  sha256 "32aa7f5626660c6aa37b8b588d3e4b4d0d875d8cb75e13c0fbd7d5134c413f97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f3564f754be2210f500ac79be05ff3319cba2d53ae7d55e0608c7b807c5aec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96d11b6a6cc41f720b31aa53de3b13c79678966b2816f54ed1890d56c331eda5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52932a5c6dcd0b553cf81b1697a9f073cd6900401e83aa5babaaa75d0e16be6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1200a292b254d487f7cf8340773c9d38838c30170adb5c65203b0865acb49f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b51d7e81df6c73744eb32cdb864bd548f49f3c38c7f638af889fa505f6113a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58014a6a5943871014df2c708d5aa1a7a3a38900351a2a2f10e3dfa98f1acf3c"
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
