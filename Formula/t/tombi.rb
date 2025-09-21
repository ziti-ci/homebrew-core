class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "7ac110a7a0e94804bfe250826839b2290b863546d6146e22ffc9cf83de080373"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0354047e59bf01ab6d1a1ad42bacc59166c5eb26b61049787d6e64f97c78d61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47d100084a389e9c99e2f1ef06b91c669dc6822df4eaf11cb681c11136c5cbe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a36539416337fa44f981e0630aa5bf156b0ae18f5cec520f418536ee028091"
    sha256 cellar: :any_skip_relocation, sonoma:        "71761fe00064cf72ddcbb4df39f3a6d9e318847c83df5428eef648ec075bb05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fef829c36c460ddc212f69c32c801aec43ee9e73ec0dc62a5af6f1cdfed8300b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2affa2f2d914bfc65bf2dab137b1f138b940cd1c3f2a948d6c4b3bdd22fa8169"
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
