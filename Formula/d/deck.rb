class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "4628d49a0bb62c2eb62634584025f021391d873861bab41ab08d7c9c4c5955f1"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e31158b6a9b38f0107662b994f7c5716c01c2670b9b6d1eb294def29786399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e31158b6a9b38f0107662b994f7c5716c01c2670b9b6d1eb294def29786399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1e31158b6a9b38f0107662b994f7c5716c01c2670b9b6d1eb294def29786399"
    sha256 cellar: :any_skip_relocation, sonoma:        "1777d388ed50a432a2d73c1ba2e401c1e46e935844ce052ef8e96bcea37fd373"
    sha256 cellar: :any_skip_relocation, ventura:       "1777d388ed50a432a2d73c1ba2e401c1e46e935844ce052ef8e96bcea37fd373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0d5445fa06b83835d346d8837489e493573ca7a7e71058921dc9ab6280b51c"
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
