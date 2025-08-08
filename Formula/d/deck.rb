class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "033f4f8630986624025325a4445d836da3f2c700351b3e186b78f345de34d3b8"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d751b8e5800608f5122e89c1de3d1ef6645c0aee0fd1cbbb548c3af871f4592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d751b8e5800608f5122e89c1de3d1ef6645c0aee0fd1cbbb548c3af871f4592"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d751b8e5800608f5122e89c1de3d1ef6645c0aee0fd1cbbb548c3af871f4592"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ecee29d693c7ce9e83a7fde50a281e5e24496491a8d82d2890c8b18acd85613"
    sha256 cellar: :any_skip_relocation, ventura:       "9ecee29d693c7ce9e83a7fde50a281e5e24496491a8d82d2890c8b18acd85613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa754ae59d65c0d0a7ec12d07b827667d36944f247ecaea7cdd2fbcbb01ce77"
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
