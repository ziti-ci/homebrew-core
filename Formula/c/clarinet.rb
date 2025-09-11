class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "38fcfd9d1af64cf34ff579b57ceee8618cc0679abc8c4f80ba8370658b41402b"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200e7de090f963fad12ccf43e6d177aed6bece2a27fd58248a3e7f241063f408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2c0052a1d6e91215c9ebd589b0bbb31c7c088beb21d652ac1765e2198142ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "074f95d39b55ddcfb0ef61109585618193dd08ad6589e211193f03402675877d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a1acca3058037d2dea5c735e3abc887226dd6b4da9abb0c412e563dd87cb33"
    sha256 cellar: :any_skip_relocation, ventura:       "9822688163ba5f2152d5a507ee34462345b94ffaf26dec0aa02c6db43a7ab18c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eabdb71ea881f2c8f0e3a5ddf81d46db94cffdf46631704e344ebfd51e601381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3969be01fefebb3357bebba41b1b053a162d7bf278f4b4c40c13f4d4a9c32450"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
