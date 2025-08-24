class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f009de95c09b100f26a2fa596fece37e2ae4d21b412fb8c81977547a6af7ad30"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "256c429c9b7dbd78e939bcaba69975f704d6399e8707b2913e55175eef553861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256c429c9b7dbd78e939bcaba69975f704d6399e8707b2913e55175eef553861"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "256c429c9b7dbd78e939bcaba69975f704d6399e8707b2913e55175eef553861"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee8807c1bf572c69b1ad79e9c141194ad277a502d7360f3d8f7c955945921995"
    sha256 cellar: :any_skip_relocation, ventura:       "ee8807c1bf572c69b1ad79e9c141194ad277a502d7360f3d8f7c955945921995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c44fb096a1ee3b113c43159949ee2c94fe9a25d80fc4f8402f80bb5b38e73c"
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
