class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.7.tgz"
  sha256 "148a81f70966e011555e37df25a87afa230427067943ef9dbe47b9accb8c5f96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c538c3b4c13feb7bb566b1a0fde838570fdd13fe1ebb60d26ccd88788bd79db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75ceefb582c177f2833d9bf3f1faf37fb967bc66e50a65950f7e3d7a389662c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8167dea2ae9a2cce7b861464df8f26a39043a29cefc7e0ce638b5e837e378d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f3544332fb6f2d167c1a36debfd3a35abbfa10b2bc5ae257c4b7a27bfe8e0e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d1cd35d442bc8a01797563320dc17cc993e5dea30f908e84ab8f8a2c9828a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a36449004f901a47c1e901a858778cfe56bd66549301f59036966225ea638f9e"
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
