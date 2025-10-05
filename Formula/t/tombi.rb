class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.21.tar.gz"
  sha256 "1abfe4c0bb63f6029615b5d784bfb1918f54567f79aed1c081fd4358705182f1"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79bf77cbb9657c4fa00d62653e370e73ffefc108d71d483926b1586a77dcc2a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8627777a65e5915632517e29fdf0e25f4b2ee24ec7bc36cb030176a3b04fd7fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0ff1c8b22d6a859b122364002af6ac0fb2d7659bf35fd1dac46ad68bddb2cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d62e35e55025ded623677fc41417c2b97df8c03b6d808db73039da29b0cef68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c11e8e45a8677a5f52ee35aef102ccd1cc045638d1c2d4a50a6ed37dc9f1c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48073c89d05c56e433e09ddc17b9fe6b60c765ef3bcf0e3b9b26636db77fc95d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
