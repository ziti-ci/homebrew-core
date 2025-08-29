class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.90.0.tgz"
  sha256 "b34855f5a6e81a225c81a9aa55b6fd4c779732c71c5016ba990db7b0ec59eb5a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd02c0e30bcb586ffdd07ce617ead72be23f6e38456e1dcbdfa9a9b783574d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248e50f3fdab3c91ad42d9efb3bcc55a623c5fd1a410bf8f2125319e4355fffe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2802489b0815daabe51f6fc7b7fa97dbb3a79aed696718505ddbfcef6e254a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "517569af2ba4e17e18a9b211447db84b1c5ced2879a8f99ee01bf62704263836"
    sha256 cellar: :any_skip_relocation, ventura:       "0304fc39aa5e2c06b0773540dc895f00e78fdf25d27ba38c6ab0b9e13d611d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85268a0b1e2cd22ecbcf9aa3f624e2c01e0c65e21f4ba45454b4857eea24a719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146e52f888559f17df2676c5bfd2591b3648611ebc36838c0505a35eae521d85"
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
