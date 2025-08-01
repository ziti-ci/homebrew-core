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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a9d47b4e02426630ed3d78f51b059ed05befca7ddacae2f8fd7d966883ea97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849ee51257241f3136fe7a89400b808ea1ec0406d65c26f74a9e2d42a6c29649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b83b9dc07015f417be44409dc6959d0f662e2cf309dbf9dfe55ec77f688e958"
    sha256 cellar: :any_skip_relocation, sonoma:        "00e69f86ec80cd9c3b92678e7bcee2940b7e23ca04609a52e0a91c3052de1092"
    sha256 cellar: :any_skip_relocation, ventura:       "b98da4d12fc02972c49129b4e4121bf8745200e2aee3b59c1875ceabcca71799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b523c55d2c1e2e831f29ff024891bcafa8e2acfaacc41c5cf5a25c43854ffa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba38b0ccc03b6cbef3e7cf650872ebc6ccac75a519af646f97c955c1c8d1a64e"
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
