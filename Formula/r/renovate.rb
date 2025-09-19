class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.119.0.tgz"
  sha256 "91d6bc5ced08085153f9bf082e78b681dd4c3e97b3981fd723cbd632cc8dc6f1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271f96aaff0d638097c50f151fa8a283096c5232f96f2bbfe528be18023b52e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f477f9712418e09dc6ee61bf64f0b3e12051eecaf1c299b3e52cab9e2f626d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a1114acb184ae98ec3cf0162fa97824b8ec6798211ec9f924b7ac75c1ba9e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "382ff35fe60270e9f946d2fb712f5494f88ca9c8f61624388eaf775a5dbbdc6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df2098427dc9c4c94fb04a7fbe4b59578ad2cbea225f58c3b1a97f59357c6e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e62914fa24648adfd746a12f8c79c58c9ed99cd368f742e474a51616c5586417"
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
