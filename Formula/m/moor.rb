class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "7d8c9c5da7e2b95cb0082ddb269da978247f5bbb62b1f2556760046b70c1051b"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9949dc09303c3b3db9f7db9c2cd59f1e622a64e6753901e0e1728dac8115d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9949dc09303c3b3db9f7db9c2cd59f1e622a64e6753901e0e1728dac8115d72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9949dc09303c3b3db9f7db9c2cd59f1e622a64e6753901e0e1728dac8115d72"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf8db9fc92ba87b7db6d9e1c6d9de61c7d12f39933d2926452204db978989f1"
    sha256 cellar: :any_skip_relocation, ventura:       "4bf8db9fc92ba87b7db6d9e1c6d9de61c7d12f39933d2926452204db978989f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57fe1c165874584e0d4ed3c69f1342b4668dcf0180492a70079cba29c9459357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5888d132044dd31b4ba30a16c24000ad17b8815dbb288c9f22649a50600e97"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
