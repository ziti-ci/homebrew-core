class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "adf467a6775d363cd92712c93ed1144c953e73ca1081aa8dcff0b8a8266ab8a3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8d671bbfa8b14bfb4c80de84d30aedf63a9e768e765b959c7bd13a70c8078cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbbd476e5a7be5ed999dcb3befbb0d776a9cbf81518759c8dc261b69700e447c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e87f1fd761e227896ba2d4650635b95438b7163cb966afc9f4551ff2c6916b"
    sha256 cellar: :any_skip_relocation, sonoma:        "32b0be00ebcc6b035f72c5859ff433a6628b40fd48fe946e52d06ca664ef977d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c94f26fbe836fccf0cf1fe493a7368e6859ca9c81e3458f4a75c65e0e2522c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36c874b4fd1d544c19752843fe199d0c31a6b9ee0a5e4de784591105502f1238"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")
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
