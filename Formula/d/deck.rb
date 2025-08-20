class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "ae616fa1575db2a50a04252731705f7601b058713f5352fdc4d3a2e2bd720dfe"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c4e7b57d6907163824a8a7c0ae6410b19e4b05192d18afb362e302dcc38b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36c4e7b57d6907163824a8a7c0ae6410b19e4b05192d18afb362e302dcc38b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c4e7b57d6907163824a8a7c0ae6410b19e4b05192d18afb362e302dcc38b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0d36e6268b3e532df9aff9b1aa5ac515b5338267ab10ad9072c12fc16e6714"
    sha256 cellar: :any_skip_relocation, ventura:       "3b0d36e6268b3e532df9aff9b1aa5ac515b5338267ab10ad9072c12fc16e6714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf9381cf8694cac373e7b55a29ebf302809c208fc07871fbf0790b03eddfd6d"
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
