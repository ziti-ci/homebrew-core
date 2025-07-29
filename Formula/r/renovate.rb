class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.45.0.tgz"
  sha256 "54d91f5cf86dd2c71a4fda965a03c6d2eab2a5b486e15b43b2cd3fdd0afb57e6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f8c2a78b2945d6146aaf7234bdaca3e634e68e1b93580490652b87284389ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c17c20c564afaf15f412547aee994005bf65a19e9bda521bc0eb0519f9b34c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97c0b5a4dbd3d55a58e41d0cc587b19708c158feba22acad4b7af435336fff17"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ff481e3809888d013121e8537792ef97efd9d3855a21521651daeb34766f5c"
    sha256 cellar: :any_skip_relocation, ventura:       "52a025948bab01df72bfd502efe4b1bfc831bad6596560bbaf6e950956bdc3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fcc1207c550f0030ae229f0b0a21f2262801cf2ee6e207651eaa71ee407f04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef553e410454d881c0a72925606c0aa69f35ef08ad1946d7402cf27780561f4d"
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
