class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.19.5.tgz"
  sha256 "5306556f61454e0abf8aacd87b3f622927ccdbb1e068c2f518cd0fad2ae4546e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cf628f2efceb5967259dbd3ed159945f3bdd6e6f2f3a8b082aa4f20aa753005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8a8ee3260ffebdf67001b5b1e63aef3ea476cb53b6777e1baab30291999889d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916ae8ab0beaa6439e50919df60c8a03072e07c624826a0945bfc643c23da95b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4e64fbefacbfedf2bc3998028b9adc5318dc6040e09cdb6f46b2e85c1fa769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f3747660e8f3c92ce4f1e9f1ebf35cb79476bd0b85bf82ecda4b13b3d7fc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "098809fefc27e295d8a421fc506fb99e9ecdd55f0db04a7f84a983523611712f"
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
