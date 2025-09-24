class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.128.0.tgz"
  sha256 "29aaa3d03abd0dd263b68c0e3bd1a6f2bad4877400f436915c4b433c0b49c2e6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ff5892898aa207a2744cbd3a92e76ca8f354fa94d72f831ca066046a17f5dc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44956f8eef9d37e638fa45ca1aea1145d77d80a0063489f383232792c6e033e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391e2a0487951fedce099f348dd4545bf82d3422a5982107f6ab2c1209bc8369"
    sha256 cellar: :any_skip_relocation, sonoma:        "7623b0c1b1758471a4d319ae29d3a102d6cd95e61ac9395f582b1342f7b8a0c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "221ce1b3a8a973df4b833354ba95efad766f4cfa832d4900d5dc3437947ed3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb66b369c43bb1cbdda854f10bf0bf1043383d21b7f47a28e1555a05533e730"
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
