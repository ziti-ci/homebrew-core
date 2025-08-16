class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.76.0.tgz"
  sha256 "7c9183b5ad2b9bdeee39fcd3f2d97db8d8cbcee22f732bc8ebcd9d24714bc638"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05e50bd502ecd16e5a2a5d17f749eae321caa77cb5439da398bac7570ed92212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d38dcc2bce35b54ea5f87cfd8b49f3bd0225645b386e099d7307f943322c6a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6950c0ed1a380573454e2312abba0d7d2981123a1adb701f57b6d4cd76a42821"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba15ca2fcfffa117b1d8eb2441559ae7d26bcdb15a29e6ff0793c74cdcaf8b7"
    sha256 cellar: :any_skip_relocation, ventura:       "8d3264b7197ffbe48cb44d135caa701d83c4f9827d20a5f963286c78da9c871d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b8c9c4bf2ad9ab2ac14ba9f0b13a995bdf13dad3a5e6a1febda77871b14b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a799bbfcc971babf3eccecb1ea51b782b70b762cd7e019d6eb321fda3b37700e"
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
