class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "7c552f972b30675d53a710cc186b301b1a022f83a04ead9300f4fff9844d45e2"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9018e9d39c036421c8c8aa4bce3316c5dfb4ad7d5e1d739546ec96c26fb655cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9018e9d39c036421c8c8aa4bce3316c5dfb4ad7d5e1d739546ec96c26fb655cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9018e9d39c036421c8c8aa4bce3316c5dfb4ad7d5e1d739546ec96c26fb655cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9b3846f7603474e4d8b410a20bfe62d2e6d50b18f942a729f7dcfdff842e29"
    sha256 cellar: :any_skip_relocation, ventura:       "fe9b3846f7603474e4d8b410a20bfe62d2e6d50b18f942a729f7dcfdff842e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94586c5d03b661e9db30753de85bb38f4fc60eb988bf88f8e13869f5dabf33d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", "completion", shells: [:zsh, :bash, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
