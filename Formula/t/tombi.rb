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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95f6f6dcbd8a61e9a9dc73031b1dd8b35c5a04177f9e3eba70c57739843d851a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e7c093879f4aa4e599c3b84151096bcbd7feb78fb044d62979a13ea1f4cfb58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09ca78b90966a95036b98132954c6fd8d1c0fd5c2ad59d76fe12a39cb97adfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8751ded998014d0224e47ab29b5b005055bc023f106855c21a9342596e4c4126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb92f1e46b6ae1982352d9ee595278cd32ac8dafe0e840298447fede5bb158ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412ceb0fdb1d4ab50fc4ef987c7357245004a0ef44c3d1d0f8175ef9c842f60a"
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
