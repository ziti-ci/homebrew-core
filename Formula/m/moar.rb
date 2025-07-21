class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "998d5a3b01b878a9af23faaacae661d1c86c800715d6af2011a5a3f5c477b3fc"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b153e613685dc763d4e27ed03e5bf1d63a4991dd48dc57fe21bde27f5d429004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b153e613685dc763d4e27ed03e5bf1d63a4991dd48dc57fe21bde27f5d429004"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b153e613685dc763d4e27ed03e5bf1d63a4991dd48dc57fe21bde27f5d429004"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8cf32632d5535a7a75afd7b1b9c7208a5628228051253ef3de26d38ae2efd8d"
    sha256 cellar: :any_skip_relocation, ventura:       "e8cf32632d5535a7a75afd7b1b9c7208a5628228051253ef3de26d38ae2efd8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7d4fd029903b3434cdc4266af2a0be362a8daec33f94bbfb227d1b36a33564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85aeed7af6ad5c06949f5612a21b0c63c3633ff24a189640fb1b4e77c2f84302"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
