class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.3.tgz"
  sha256 "770d9b646998e3fa8ec86396001583f14d06747c95e1a7fca3cbf8a287d59343"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1eb99928a8a0e0ee45347c1b9c70e4b733a2445ebca884c437c00253f5c08700"
    sha256 cellar: :any,                 arm64_sequoia: "aac52dd24e3f356f6030739e8e7a0013fd42443a11a3cd00a76b4dfecb183406"
    sha256 cellar: :any,                 arm64_sonoma:  "aac52dd24e3f356f6030739e8e7a0013fd42443a11a3cd00a76b4dfecb183406"
    sha256 cellar: :any,                 sonoma:        "1ca0ebf9d2bdf0d0326d02cbce3eab9922ecd0dc0ed14901b9d1c89817f16d86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1e01ce8731d2c9a1565b3d2101054b085faf3a683a3ab7001e4e584f2b49b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33f48e0235d3c83018bfcd4e913119bde8b842866647b332d85a105144c2201"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end
