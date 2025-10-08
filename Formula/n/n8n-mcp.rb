class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.0.tgz"
  sha256 "8b86a5f829fb576d94bf8bf0c78bce31ffd974be575ba163da335a89eef53f26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08be40a3b4f2e60fa525a834595fb995e908819e751230de6a49fb6eeac073ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404c03dd0841a4c5bf7a89d1d19afd82b68d053808c6cc7a0f7c29ecb64293e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "189675e2538f9d3d08b5471acece3bc3223491d078b2f0b94e734f88acfe4153"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d1b93513c42c919257d33eccb7d62734650e45cddcfba10e367871c6bdc530"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dae77da7a5d919f1a0075b31bcbf1796186bf1c333f44ecbf5bb908765479a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21134ff89b6ad2d99127053d3d1a3533878b8fc398350b997bba79b236eebb86"
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
