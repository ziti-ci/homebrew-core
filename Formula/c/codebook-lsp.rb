class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "38bd649d0c22e82a5c9186bee60f9a90c19a13c8f253ab2a4a42b34c58cab106"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f08d38a3bd37cc891507526a41143b8a22e9970b4b3fa8c6aced6b133d4dd14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e11767e24ee929819d539ce5c2a357fba2002fca3c68bf0b52794c9e3047a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59ca7ea04c703d698b40219b179a22aaf714ede9fe0e472fca0971594bfabd25"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed74193a78f2a202c06eecd63b64d9bd2f7b1ebb2aeb85e0f57ba6c4c72a3ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d9988f5a80c0c0c1c7017221c55df0a71c80c118efef7f45a9aa7e35585d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7daba107eb0d1c03332d655ad653033bc0d767791efbcba3b200ea9ad0715de0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
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

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
