class TypescriptLanguageServer < Formula
  desc "Language Server Protocol implementation for TypeScript wrapping tsserver"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-5.0.0.tgz"
  sha256 "2ab4e5445cfd29e42edd2714f651c0b9d6beac4d9473f089de758de77598aeb1"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eefdaae99e0290039546af2ef5af88b79ce99cf89082a67c828ba9b9b4d0a380"
  end

  depends_on "node"
  depends_on "typescript"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules"
    typescript = Formula["typescript"].opt_libexec/"lib/node_modules/typescript"
    ln_sf typescript.relative_path_from(node_modules), node_modules

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"typescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
