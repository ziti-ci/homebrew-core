class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.84.0.tgz"
  sha256 "01bbf2d4d2f56d2a117d8d97613715adbe1e90ceac97f069b4db99ffccd2bdaf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92cc10cd625c45946a4bbe07d39521259aadf0fe7156077c8ef774cb81f72644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b1a6c72c1dfaedb9f0b3d28a477a970b8e4fdcad54e4acb631ffaf969b410e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e754cdb7ede8fdbe6f2e2fea7cb8f74cd68326a86b2b3c865c4a941352b4bbb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afda29a1dfe7a2f3a1ad3435258e931c5f142c0a6d650d87b10dc0feb5c0970"
    sha256 cellar: :any_skip_relocation, ventura:       "f11b62270d09cc4b52a8e9c6d407e9b8a1539d24aebc5a046366dadaf92a66fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f6874b1ddf540676942b671d5f8b4eaa0a3da8be779ffcfe81072e4dd2f3705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20f7102372991621cca568dd8c6e981126833197d9a4d136e151a588b792af9"
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
