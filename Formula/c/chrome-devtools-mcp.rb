class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.7.0.tgz"
  sha256 "e9fd5e7c46ad090102ccc7d0bb7e1f179e32ed97bf05e1685a89513917942848"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e40049ef0076d7ea22d5f0902f5366d9a2cff6539a91bafd6a44bca7581c321e"
    sha256 cellar: :any,                 arm64_sequoia: "d4cfe3c171c8ec417d55e3e494d9832a873426cbaf4f34d65d551a7a673d1559"
    sha256 cellar: :any,                 arm64_sonoma:  "d4cfe3c171c8ec417d55e3e494d9832a873426cbaf4f34d65d551a7a673d1559"
    sha256 cellar: :any,                 sonoma:        "9778387a771318a966111bf824cbf91cc5b83907de99b545fd093a16af168af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b863210cf88ae6550c56586e55815b9093cf35bf12d3750adcf3ba9b4bcbed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fecae160b2c0a637000d97939c107d1e713a310c6c6749e1a24218b351243ef0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/chrome-devtools-mcp/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chrome-devtools-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"chrome-devtools-mcp", json, 0)
    assert_match "The CPU throttling rate representing the slowdown factor 1-20x", output
  end
end
