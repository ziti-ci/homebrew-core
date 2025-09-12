class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.110.0.tgz"
  sha256 "7f72913b364734d5915e25398b1e521c84e142a078864885bcac4a559165bf4b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "768cea153132bbb5094d69fa23e18213dde46f3ab3d6488509cb98c6f25de12a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fbbf4e7d6a2d3a0b6e3c2f078143e5afeaea7b4e6b7d20d3b174f6377ef7bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f93f14526a8b786cb13512a04b9d4fe96d74f2c056fc0db2d250bfa5136fa25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f1e96018597e0b17a5116cb701e59d11ed3bfb71ea16d729326f1b6a67a83a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "050a10e7f6197f1c704250497e0a0b36a0d4977da1d7140ae52f98c8f8a653d0"
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
