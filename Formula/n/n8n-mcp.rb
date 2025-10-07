class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.17.5.tgz"
  sha256 "f6475ac20e01ff7ce4c62b54c07f44574413f9268d560abe30629de3253caf3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71a69d04f73d01ef19701e6bb9351bfe1fe32f38bff5fdd4593765de31e348ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d7acb60ecffafe09104a2986ed94f1eacb935d08af9a55e4de6468944303c22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a238930ec1cb9388c8dc9015488364eaae1064d812d3e70fb383e286c9dd2cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5a4295c68635a0f6afc39b96c06009e3d0071099818ecf640cf29bc6c6aa55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf81e4cb1b8b5157819560e1e0e9b3e4cae489c837d2787c244c0a6ce4b44b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7f38e960ce41453bc1bd10eebf679f1e6307e1c5d913b2957d91870f1e3167"
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
