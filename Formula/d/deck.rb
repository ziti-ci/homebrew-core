class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f009de95c09b100f26a2fa596fece37e2ae4d21b412fb8c81977547a6af7ad30"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11f283a8aaabef35c5241f644b73afb495505b5cf794b7f81b96ddc8c9bcfdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11f283a8aaabef35c5241f644b73afb495505b5cf794b7f81b96ddc8c9bcfdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f11f283a8aaabef35c5241f644b73afb495505b5cf794b7f81b96ddc8c9bcfdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0dafb528a97ebfe4aa315dca446d1e20aa853fbaf1ac95e66e9efc3377a66e4"
    sha256 cellar: :any_skip_relocation, ventura:       "d0dafb528a97ebfe4aa315dca446d1e20aa853fbaf1ac95e66e9efc3377a66e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5fb6c5f052429d1bd80c89b32baa3b9643f3079a427bc5e05b46592eeb3ef9c"
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
