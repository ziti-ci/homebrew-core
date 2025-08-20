class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "4927e3d002d2dc1522c4c9363e40a347b22c48f51f33321d179baf9ead464e00"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849cdc697df5a78020fecab3b4052f47d95914fbedb47714c5e5d8913b79ec8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849cdc697df5a78020fecab3b4052f47d95914fbedb47714c5e5d8913b79ec8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849cdc697df5a78020fecab3b4052f47d95914fbedb47714c5e5d8913b79ec8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1d048a4dd7868d99af89a1484a07e796a74f2a2e7561b144bb3def325b62a54"
    sha256 cellar: :any_skip_relocation, ventura:       "f1d048a4dd7868d99af89a1484a07e796a74f2a2e7561b144bb3def325b62a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71520b62de3166d952b5c866df4a3237518ba6f9c8632b4988e8454e8496d7d"
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
