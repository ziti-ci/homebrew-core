class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.121.0.tgz"
  sha256 "5c45e8b45d6d3ca579cb38fc3f11af28950bbd8673527afe0062847cc812ad00"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63148b5dabb33774c711ce55d128b0098d393b063f84a4a19aca3e947de5a0ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "595abbeedb2c4c8290ad565c76d11d952f2aea5a64875f93729730645633681e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df87eee13ae0ad16d600ea7199c22b40f06485debd998e68d985b94d779bf651"
    sha256 cellar: :any_skip_relocation, sonoma:        "87601e3850497229fd8ecf535e7105495a9504ae180856f3fb70a7142a2565ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b61b04d88a81000859ccbe3325c6231c3f11c3b6c67395220e21780dc2436591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8abf7ef92491035bfd1d0a2c6e56638c702d4fcb1047a3a70c0ca894fac11ad"
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
