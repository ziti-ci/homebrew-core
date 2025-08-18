class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.80.0.tgz"
  sha256 "2d8132c6779dd65de650905816d026b3d07fe386ef1211f694fe578a85d5a969"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57152dd9de8456bf66282f625cd5cdff2ae9e863bcaeaa1b5ecbafde52a051c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae64568267ab27f6992ab80d5d951cdf29e7974385f65bc3db743b3007c59aa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c26c1c55bfd015cd1794190f47ca923e9ab616d4bf3e046e4d75059857668c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "145346eaaef3827c4b38ec386bfcce107b13ea877e969cedce96bce2e9a3a89a"
    sha256 cellar: :any_skip_relocation, ventura:       "3e2fd10241e525a70d5dbe1c91e8fe08e113d381405b5b7f628495451bbc97d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98e6ec06e6ba6e5d5b1d3ec633ea4c9cb975f68d3126cb5777ef21a56cc88707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98804bc9f7452646bade94a4d0ec22a18070c267a4114ab27320e92b64523c9f"
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
