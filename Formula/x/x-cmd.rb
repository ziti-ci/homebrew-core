class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "52a79aacaad7c95a8babd7bfad0504af4e1baf49ec73f8b073cc3cd80153482b"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "284df4bedbdbaa3d7cb311321cbffbc7933461354da7a6434988f16644e5f951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "284df4bedbdbaa3d7cb311321cbffbc7933461354da7a6434988f16644e5f951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "284df4bedbdbaa3d7cb311321cbffbc7933461354da7a6434988f16644e5f951"
    sha256 cellar: :any_skip_relocation, sonoma:        "de8d6c07169c659edd1ad7dfb818efec77f3887998c3020214ca165c8dc2096a"
    sha256 cellar: :any_skip_relocation, ventura:       "de8d6c07169c659edd1ad7dfb818efec77f3887998c3020214ca165c8dc2096a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9d8413ab96e6904799dbbe42d1dfb17a59ec8654b2faac6664807edc65b4e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9d8413ab96e6904799dbbe42d1dfb17a59ec8654b2faac6664807edc65b4e2"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
