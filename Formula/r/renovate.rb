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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c924f6273eb748da484080d41458ef92e43b7e851d022ebd2a162dde4a2694f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10efae2786dd8a0a410c08d9285b8976abe350d283290ff928bdd4be48914c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c63e55e77e698d66cc7df2360c83e71c45e6ad743f2b2ac7993a77a870c8385c"
    sha256 cellar: :any_skip_relocation, sonoma:        "26022e20cc12ddd173fa68fe94c7a965e0c73d3c7479f7d85a4c6dcc78441345"
    sha256 cellar: :any_skip_relocation, ventura:       "e6a7950aaaa16f8e1ad2fb871af78dd7e0a304c7d5fa16f3efcd7ca6b0e476c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "681d409920723c62490f11e47e97c66130d6cd8fa7d68a7408307de5f1725ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9cbe9235bd119e34003cb5293d45015b0e8ee11606c204be0c425631b465f89"
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
