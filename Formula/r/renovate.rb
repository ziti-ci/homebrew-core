class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.99.10.tgz"
  sha256 "99f5c0ddf0890ca36c7d9c79a5a110c86458cfd17bd99228a04fb5afb66ee93f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239718b8935053c5e8e7fbbb8e83e494937fc69c1b79c75ea801b21b238c003f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360dadd0ae4175fbde6d8116c32a552459ca646dcbba51dd714a914ff1732f3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "240096c7342982cfc14f5ad3b438907c2f214190ee8aa2bc150654074c893d79"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c27cf1100a304f3519906a5df094cf191863210975bd57f5aa2c86e3f1f0966"
    sha256 cellar: :any_skip_relocation, ventura:       "8d7001cf8e67e5272330c959c7e45aac43b002ca0769514874e2c553120eb9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b8718c89c4a45afaa6452af8dad62c8816efed0bdbc2f41fd2189086ebf014d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b716da9562d2ae30d85cc9bee58cdabe622ba8c726b8d119d2be261d3bda536f"
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
