class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3e7bbab07e6ce87e1d5b5316c3098db98c1589feb5ca008a8828c0fd4ca48e5c"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48844cd8a08e93d3d5efca02f81ac14b7e8af0666dad8038b2c6c64f3424fd86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48844cd8a08e93d3d5efca02f81ac14b7e8af0666dad8038b2c6c64f3424fd86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48844cd8a08e93d3d5efca02f81ac14b7e8af0666dad8038b2c6c64f3424fd86"
    sha256 cellar: :any_skip_relocation, sonoma:        "99f062a01120382dfa9d5d9336b1f04f28b98d12a783be3c61cd03d43a1343be"
    sha256 cellar: :any_skip_relocation, ventura:       "99f062a01120382dfa9d5d9336b1f04f28b98d12a783be3c61cd03d43a1343be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d284873e2da0ced9040b0260bf4d63dafa7d3cf355c871906fbf28f28e53b4"
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
