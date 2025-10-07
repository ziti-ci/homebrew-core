class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.17.3.tgz"
  sha256 "1bce4c62fc0c5a8e8a19235a3c5885856b63d4a8d0268145aa2ef09dcf737132"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8945740871ef51470a389949d1f1e9b96d711062dc3c53e1fe887309b45bd73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78ff73c2887ece24e7b46ec3366604efe92b109520ae44c6a33d91eb5be4cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e7052f65ba7342327d9588127f837e626adc781fabfa85f99e212e947cc04b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4de47ef0d244d18962374d5cb2df4a38be6de7d0735701dd43cbca8db423985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "775edf691ae2c961ccdbba72e4cd6bc5bd725c4b888e2c0899a08810e55b0512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c1bc97c597c54320f8aa07890beab477f7c3306d4a2b5f1d775d4239beb663"
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
