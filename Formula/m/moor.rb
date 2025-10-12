class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "52b42419e565e2bc2aae0b3cbf4b4e6539e8a7daa5ba97c5384982e6fb8c2f40"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3489f30618775e63a35e38ddfb939bdd92ad5ccee4258f9ed5940a3e37d54bef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3489f30618775e63a35e38ddfb939bdd92ad5ccee4258f9ed5940a3e37d54bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3489f30618775e63a35e38ddfb939bdd92ad5ccee4258f9ed5940a3e37d54bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "1510c6888c704655c9d90b7e051f410e7c7caf8aeb2dc52d021084a558250191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7348f9f1b5ce5aa334735e090dffd940877c4cfe15ab14ecd088c8ee030ce16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1766d86c694b81d53a989238065bac42d5f4f5357bd6cd7f3cee25070ba604"
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
