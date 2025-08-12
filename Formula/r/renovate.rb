class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.64.0.tgz"
  sha256 "c7bd6d531dfb33c24962d25bc04ae98f08361ef8fd699a27d06068c6f8464867"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dcc18775401a64c7134892d6fe6dcff033362457d054afb396b2c679aae4b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a50f03de38d484757d2f1d0328c76b39305694912d37abfcddc1f8aca7c75a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3beb44d987615a100fddd2a1291fe091138e614a11a004f179ae682ffbdedf95"
    sha256 cellar: :any_skip_relocation, sonoma:        "e011913e58f842733fbe9ecd08749a13c3fd413af57bebf2d6681fbdaee424a7"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4d18d622b01c3965ce6ef85d51c2d07d829bb303cc4fedd729a105f9c93b8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d57cc7afa29d31bb6e697f428f7f8818470564487368be021e8d17e38839ce84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b35187a4f06b08755e5254ee24b96129c9fa56aed20c13049f73f2da2b68a921"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
