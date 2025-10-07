class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-1.0.21.tgz"
  sha256 "704cc53a010b441ca52bc22e76e5abce76591614a24fa3b01280126ded6a4113"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81d8c58e1f39da064f8e601dc4d41033b22aae04893e5afb5088c6fb1d840cac"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
    assert_match "get-library-docs", output
  end
end
