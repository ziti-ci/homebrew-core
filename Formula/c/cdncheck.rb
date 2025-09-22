class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "19702364291050bd4be214ea2d42394aa971cbc2441cad15a8391f96cfe4907e"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4a49334ffe72354f1f06b5b85842b8e7baee5a5285d2d3dd0d50000e85861ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53937e37fcf5a1db869b825ef7cfad4738d039554b2a75db125f7d219bc99fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3b3a361cfd05c2d2d2c62e754e817540ccd8a3cc5fdf924c667f5893a4444f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca670fe11ae850f738553bffac90957673bb2a6eab5d37ba81e03792e755b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b0a8e26c53630ad4cfa250790f712d10dde5b7bca557886fe9cf1c646f2726"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
