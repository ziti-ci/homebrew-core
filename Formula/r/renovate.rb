class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.50.0.tgz"
  sha256 "fc4e48115e32d1ca0b630ea074f3dd5fccb8d6039bfd2ec3fd8df0fb05735495"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a90f06ce89d98d0e76c8bf5ab41f1733602db8b78732feca0b5a379041b986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3abb1de3ca4f1487e4ff9fab130266ff47b1bdc449f5e5c9199e3e42082af22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d9aba1d1b7b247e222d5ac4e4938ac512bf8f0aec24a1d41c6afb874ee10170"
    sha256 cellar: :any_skip_relocation, sonoma:        "93067db0d7b1560359e3c0b843195ca2b190e152db50bf0a708ccd183c4732e2"
    sha256 cellar: :any_skip_relocation, ventura:       "b39c01dbc51c6c8ad473f23c64d2aabfd9f37bba39eba9bc644d59fcd49b6596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e72f82c5435f256f4e571588dff5ca46a2ca6c3433d74d767f7859cb7685ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a589109bd48a6f70720879e014a84e6734a79e49c99be8d786aced0e0e32732"
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
