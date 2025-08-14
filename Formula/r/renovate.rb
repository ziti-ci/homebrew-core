class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.71.0.tgz"
  sha256 "a883ab4b07f6bf6293773fbc5187e80432fe13aef8ac1ae8e4eab9440789e29e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da92538a074a135f2272adcf07eaad9ca07b48f984d41889793f92cc7729144e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "192418c5540404952945c5579ac5be3a05623a46069f439e72e8fe58de527aaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "682d0da66b94c32f3078a97ed68eb8e67c0c54363c1f9d13f8284aea74d06aa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "232921325b7353d0724d9f310afc9727b94b0ff0db47ebcfee3d521c6a77b362"
    sha256 cellar: :any_skip_relocation, ventura:       "087b307042344700f43a0ee783fa3dff49bed4d8b00bdf4334a8100ee1b1d323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b531f232729161f633827588815ff637cb2e94b1a3a17ca5159e825b4c7f12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e7ef4407f34c3a1647e8c104c39f4992ce520b417f87defa47a957b6ed50d7"
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
