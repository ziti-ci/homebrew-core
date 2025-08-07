class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.57.0.tgz"
  sha256 "2f75385bc388097c1a8a4df2fb1e337573fef642ef24c174b8c7d18caaba86d4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e715bec5c92183ac9e00e0ac746be1cbc3176ef5b41704af09108c0065e7f61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb5c390768c3533d97eb19ef543efc754a93cbb7617f26e487f1f44c495c1ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7b209468493360a5be7d8cd9649773b649e6fb1ba1fa42c864d1d7f5bb0af21"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a271f5607de9283d4c1bde030c095a4c60d3458b1b827ee3e7292d0c63a977d"
    sha256 cellar: :any_skip_relocation, ventura:       "e316f2618b241926be6d48d14d0a30771ddeb08875baf39918dcae7ca6d2f688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1bea9fd6bee231b46ee1033209366036c2c518a5f6ca70e233c0b59bde21df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4396cca21c3f0f2d35d07a01c7a9552635465c78db2dd6824fca98e012d06ca"
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
