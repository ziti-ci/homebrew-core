class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.55.0.tgz"
  sha256 "a888142970296c75ad0fd2c469b536d69d8df4bdec3a685975163e049237af3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b0923b7d83469e9f178b75ad1f4e9c5a2aa3186bad93b48f019893e5db2c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81aa71bb436216f998b67d2a5be1ea882290b32b5c2ab616ca1935e49878a75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e3d0a9c38632f44ddcefc3d2125596c484591669c7567a5e854ffaa42e8610"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e9c41a879b0e3b2f0c41b059fdac0f6ed1ce7bba2f6cc4684aa62cfa1d6c71"
    sha256 cellar: :any_skip_relocation, ventura:       "260039f03f756d31f3253751d982f29b8c7dd5ff0a3ce9fd819c68c6686b6c42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a411ed6bb324dc3d394903d52148fb2a5ba9f2cae26cff1b680f97e1ae1fbab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408077bcbf9824919c9fe0f289829f29eaa64b2d9b43cf8bef36c9c8b8d26bba"
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
