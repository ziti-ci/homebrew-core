class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.67.0.tgz"
  sha256 "7a6e8c1b2c61d4d5e0f5c467f6fc1a183fc6e727ae68afaceb41a171e2fd135b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6ebe68a01abd1637e6f17a5168d923a78551b6ddf47025076e1307dcb68e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a549a47de2a2d7f9e6f84474eb09e4775b17fb7f8531ea531c720b78c876e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5d1de421a36989ea820546b66dfe2eb901984fe4aff974de399a3d77f5b71be"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a1db3d766b0c685001002b5c0e8a834ed5e7cdbe8a3558d4d174d48843183b"
    sha256 cellar: :any_skip_relocation, ventura:       "5a184afe74194e9e574fa6f97d0f316d665d13aa3d626c51633f7d52f546cc24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b9a928fbd630ce6e79b049c694a325f10ae363cadc748b714e53fee78e0ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc5d8ad4b84e44bf8e93ead00e977172765273440711f3551d734f7b7fa0ac5"
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
