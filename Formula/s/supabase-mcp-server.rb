class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.5.4.tgz"
  sha256 "f8423a66cd13abb60be4d7fde8b9b893f2f3cd101e77fd09290dd08b72e7087b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74861a0f89f5407d21fef21e962d0bd6a06b01dcccdc03b33b01811971e01937"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-supabase" => "supabase-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase-mcp-server --version")

    ENV["SUPABASE_ACCESS_TOKEN"] = "test-token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Lists all Supabase projects for the user", pipe_output(bin/"supabase-mcp-server", json, 0)
  end
end
