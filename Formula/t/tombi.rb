class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.29.tar.gz"
  sha256 "5fb406f34010ff7f4813a6a9de79ea129559f86ef3ed1d2939cad286d74f0cb4"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2f3b1f086473d1eabc09da8f8197f07df5964861a4534d27690a1427440ec44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f09e3293b12b708f9669a4b65725ce6105d37ebbd3cebc53ca0d344fd01517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d63830775fa9246573f26b809b57f2871f950274143da5cd651c2a67412e5d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "9acdbf27444765c71646598461160c11a8cfc757978c48b9e695aaa516466405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "067fcb6698c881478a2739a1a8c4984a37363d06909570c9bf62fbaf69272888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a736d289bbfc7581a22302e8bc9b01622c8abcf5483885cb96dfc5fc367c008d"
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
