class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.39.0.tar.gz"
  sha256 "4e79e009d7d38cc25233aa0ab17e1e435ffd5a634a1c14d15fc7aa4d0c4c90bd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b080d5f4d82cecd8d475530d49df6013f9778da5da6688dc17901349c87459e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b080d5f4d82cecd8d475530d49df6013f9778da5da6688dc17901349c87459e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b080d5f4d82cecd8d475530d49df6013f9778da5da6688dc17901349c87459e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d01994a6ce064a163928e939f9b6205f385504f719a4f13f84a2610c8b94e15"
    sha256 cellar: :any_skip_relocation, ventura:       "1d01994a6ce064a163928e939f9b6205f385504f719a4f13f84a2610c8b94e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c0b7e848c8a3980a7c1162ef6812be720a73e69bc2acbf1238fa36ae6d8984"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
