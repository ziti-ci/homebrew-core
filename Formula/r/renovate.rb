class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.107.0.tgz"
  sha256 "5f031dcd3b2330b24771087bdbe3793fc6d6febd258db48a684e865ea2034048"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59311553fb5c1d75de30df95de89cd10c6a4f3385cb7f9443051de3a262ac4b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e32fa83e27b2a5872832b7e4183ca165df02522d64ee65c4a256431af3be4e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83bfa045c01bf4a51fa88b84af8de087e24d568478b50ed624fabe4482bb48bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f4f64f7176571465ce9855e8f8515ce8528d40f70a8aecc802c629aa0db9d9"
    sha256 cellar: :any_skip_relocation, ventura:       "edde24a4506da68a04e996b8e27e3c08f5e059eebab8806be82ae1d6e3efc129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae88f89c8b72154bc78229f585c146e36ff89d27d98317f0474832be6dc1180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2c8fff20aaa1118f2c1d6e1389a71d612b07ef630d08180b5a908216a04dc9c"
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
