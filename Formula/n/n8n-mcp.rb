class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.0.tgz"
  sha256 "8b86a5f829fb576d94bf8bf0c78bce31ffd974be575ba163da335a89eef53f26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ad2cb55a22e31b3fa916f33c1aced6fc7c4c73b28b4398a312072f2cfbc34fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb087ca784799c4634dd918f9377bb15451f4d3767eef7b90bbbd6ab649e25aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "456f5a1f0d1c0c7658200df4e60b4969ccbf667b0e5a8bf95c6eda1e58bf0c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "26fe693c13b568e8ede1ce9263a7f09ed3a7342d13ca062c610dd27108b5fe34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dab574d36831e3a66014da1c33e7dd8497e05a033ea2cdd20c15fae534dda2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06d82c7fee199a1b0f28d458db10d7bb9b9e9f82ccac7498f7f170b659ef1b9"
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
