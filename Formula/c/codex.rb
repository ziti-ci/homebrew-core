class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.12.0.tar.gz"
  sha256 "4119c5c7603ba08e1672806db0fcfbcf71a3dabd5b026979ea26c3e5ee30828d"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb319533c001962939edb58670a7c5740a5ff456403ca5ffb2a4fd93e98cf6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c45b1fd111ff108a652fbd6fdcbc4c4c75cf36c3979b0fda42aba14b768dc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "711da5d6ccd8642807418a099c9d0e1524a030151bf567e2f370ef17be5d4dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9384c6775b5c6d016894c5885cfa938f30f68249040453b187654e63a2a0aedd"
    sha256 cellar: :any_skip_relocation, ventura:       "eaafc30982ba38685b3dd8e12813a28cc734f4205c5aa1efa8fd1c1d0c12cd53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119cf0b0b1b01776526ec71e6a218b381e5fe30d3362b20234103ff3b72b12c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "445bb60bf664924e0af0416b20e23c33f3fe623dec3855b2158e049848255a47"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end
