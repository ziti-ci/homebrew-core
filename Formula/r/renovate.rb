class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.97.10.tgz"
  sha256 "deef4cea787ca4d86bd7bce12d4d418161f0ffbb1c0725189005a6be5921e031"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "382cc2ac08eb0e3d629a2afe60b499163b6b6a37c5aab4fa0be566ee0342fbe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d837c21f4b8cc7956d8e4c49a68eac6b0267636563b9d8d0b31e17517df6cad9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99a908025288ffc8f41727ba4005354824f6b980b19826523b29a144449dbdae"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a598951b5d092f40d00326806c7a4fc2b789fc92121d3869746d91ff5c346b7"
    sha256 cellar: :any_skip_relocation, ventura:       "67dbd9dbb6f5287d899e011f536154ca2e29e9991aa8d24bbf7578c1dc85d420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751dd503f3b65afe2951a176d074a723465f1006ba47780826c0c71a7741198b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2fe0ec59232474c9eebd0e0ebdd6c16098d7af85f50e32b1888bf5f4fff206"
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
