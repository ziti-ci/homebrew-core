class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.28.0.tgz"
  sha256 "a67c891ebb33366e1c34331fba84e530c00870ca1c64b279c254106d0f86aa9c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf7ab4357f313aacc49571e2a0b27a611eee838d640e111186e299f72808302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2ff83a8129146b1a71e6671cae48c4812475168b88c930de2101129b013475c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0914a6a68b7981fe34c6eb421cfe7854d530f48a843e7514944152a5e94bfd0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f590ea0d410e032a474466454841e6e20bacfd2e7e75729e7bb8053601508eb"
    sha256 cellar: :any_skip_relocation, ventura:       "79562ba3f7469e5f00b7242e8b7302668c109e226edf859d2b363ac0f882ee3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a82f45f2da0ebb8d150606f8ad2dd8ed25a309b7e361ad1ff6a22425678b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c7ed623b2d8351fd43e3763699871f2dcd7ec6d9084819d4ec0756ad6a205f"
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
