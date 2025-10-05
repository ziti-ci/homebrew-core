class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.14.1.tgz"
  sha256 "ca2d0f2e058ac61657b97902cce1826dd24ec6ac066b74ae929ea3aaf9fe6505"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd82dc7c6d6ac62e7654fa9375c615914aedf413a63159a4381595b06812fe39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53a70a5a3751e38158564155aac14e7528033ab593031fe8244e3fd1c408b026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f32421959461313da0356f8c3a68e2f9f22b00d8c3846bf7cd24cb0749c868d"
    sha256 cellar: :any_skip_relocation, sonoma:        "749459700bc0f0e69e292c7cc9e90d9f0294e393edbd6f16680a1da82b549899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54818c49b1ef06f04cb4b775b337fb1685606861b10ff6f413558507e830f98b"
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
    assert_match "n8n Documentation MCP Server running on stdio transpor", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
