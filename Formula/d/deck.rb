class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "f37a8909682518c3609730ee347a2bf7e704c9eb101133c615ab9bb371df9641"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d5b06dad3c103f1f8b1d932c9ca6494aa7b2aabff4c2d36fbfa2f5d963b8007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5b06dad3c103f1f8b1d932c9ca6494aa7b2aabff4c2d36fbfa2f5d963b8007"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d5b06dad3c103f1f8b1d932c9ca6494aa7b2aabff4c2d36fbfa2f5d963b8007"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97de96b0e19505903c6d54b7828a52cba9c330f5dfeb778b59f036f6a917dbb"
    sha256 cellar: :any_skip_relocation, ventura:       "a97de96b0e19505903c6d54b7828a52cba9c330f5dfeb778b59f036f6a917dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42cbdea094a8ee1e7788483647c68f9d83522aa97094d288b8c86890bb60b192"
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
