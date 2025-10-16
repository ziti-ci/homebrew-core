class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.33.tar.gz"
  sha256 "a3e13e394a6e2d0d563087247be5b316043812e96ac2fea9d4aa90538cb8784c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "142392e41241b928209c05f1d6bb700d214ef21a8610711e0ef7d695c70d1ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3708d47433c9407b34e38d395795ce1cb5beab5e40e79ef4f4ee53155eaf0207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "760d7fb85fae1690e0a6d01c1d701c084bde54fcd83dbbc199a1df53de304a96"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c32e734e6a9324982bdfcb0a356f10c529e9a7bc1360f0c35e41a511f75282e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3281fcba7bf0d8f8e7c145aef42e738e5b6fd0ead266250a64c8e8a6127fea42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c9310628ba6df5099221abfa403cbff2178cc4c05f36520c5566f68660e37c0"
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
