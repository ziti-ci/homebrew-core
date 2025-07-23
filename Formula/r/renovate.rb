class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.43.0.tgz"
  sha256 "be0e800e4dc9a2877bccad410fef270fa87799138b0f3c7234c5341449edb233"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "956f727f5af1c0e153f66f17930fe20de48464401b166b4f7bdb26ff5ea0024d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8364d8e88588517091e859a281a1014e6f1c3297576b4cd1f82629f35571ef21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80e0809c741b1b33a3239960e6af3faae3d8a1ea9d9a691366c4562a16b2d3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b13883a2dbdcc5e1478dbdac492de21b83ef539994a2da68ee502c031eef66b5"
    sha256 cellar: :any_skip_relocation, ventura:       "194a59a51c3b3a9e2bcf1224d23f4e3479250268ea61ec82c6d6a7eb5be33586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f48707cbdca867e034e1cb1916fcbe03dc3a09a6930f09f2ae6964f1a3a9738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8151b097a10276e0e5bbcf05ac7623e14e12146505c67e03c14c876ae8897db0"
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
