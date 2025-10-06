class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "395af3656b3ee23959f2f13397a15b599532ab1344f45a809c668a74ca57dc04"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bf618ba1ef3305da06ad698658e45cc2cf633d26706ed9f9bfec0b2e3b6ed9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a4eae3b9ac7d61acad97d973f54116af2e188c1535c711c388c0057ccadeb62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39b7568f204e551f4239eeb6a44928921e9210d09bb3af084fe1721fff40bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c3795f314ec00b43b0ec6abd03ab53d82dd675e8bea7c0de8e04023ef27b3e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afa95a9a47be953273961b851f940daef16d87be6d924a8773d61189f6396f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743b92f9e21804b2b5cd53013c80bc549bab97c2bc661f4f29a7f3c5226541a3"
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
