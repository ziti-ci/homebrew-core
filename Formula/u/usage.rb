class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c236755261a9bb85ecddc0c3c0a34caeb79e23e77bb0f1c0d0b6847430250077"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd242dc206be5261514aaa2ff1d58da2ab96165397b5392433048485f7db2cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2da1a0aa8c39b74ebfe6e7523c73497b0609961013d4b4c5e1021b145258ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d24084a65e1200d771c406621bdb11bbdbbb406406b51d97d56559020e1c7d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "85353abacac48e1f858fbcbf83ea5eb7dc7668846a371623a45dddfac76981af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "827fa5983ba16fe9546f2bf36de42cac7129e9a5ddc4ae529225d6abdb27903d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38742a4cab84e4067cbe5e9e4d029a3ab3746a8f3049a7a661e51da39364a108"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
