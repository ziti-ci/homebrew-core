class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.26.0.tgz"
  sha256 "b3f9149a045828b83736446e8c42d98cab6ff91bb59b6fd52109c4fd6051539a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b98fb6e002cea337d72523345811abb6f5665ae2b5e9ffab8ed31f08b011c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347700f91489ff8d84eae4276b569bea6a204f97d67a81688d01c038ddf3942a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52152ac8a3323a2823daa485a05ab0de9db808187cc2ba1a4d8eaceed3d22f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e4b372ebad31eb2920cee3bbe37b8888db93e68f0c09b3b51430cc2b25d11a"
    sha256 cellar: :any_skip_relocation, ventura:       "ba37cc03f0f8c4ed9f782f6b599d0f25c0f31ae7e79368485b2777f4d0a6722c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f550dd11088df6009c02edafa7f9a2215234a539c59f0ca39eb8a43412dcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c3e2a2d236b84e2e1e596368f5401bdd5b7bf25348e14aa372894f37b6c7f2e"
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
