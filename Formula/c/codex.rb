class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.26.0.tar.gz"
  sha256 "6a656aa8ffa9466356ed133317df09cfacb8c78287fc4eda5ae113c3803dbbfd"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086df1646c06222d2e0fcccafcb13082f22cf38d6ebf1c1c887a00ac7bd37f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1b4d7a012b9ffd04d5d849758d4413e6f1b5d2f851889501731516ef07f1eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e85dc10ec2cb87987c900b0d572d4dff585c41649dc014a90634555c374a77ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c18c9dc737e18849283ee64b224ba79ab540afa56a8dbc824b2690b259e9de06"
    sha256 cellar: :any_skip_relocation, ventura:       "2347d4108458e0f9f3298ca5c6d790218d799ccfbb0b0cfaaebd7cd5b82222f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa62cf79da7797686a7945e0ba4f9be50143ed2a8b08a36ffdccfc78b4604b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa43fbfaae8e2cbce89983b37d3756f3b267ed24d1636cc08d550ccd3cbc3bb"
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
