class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.37.0.tgz"
  sha256 "3fcf5c4d055654bcd0e03765686ed5b627edb5c6e752683f8762b74393bea072"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9528a9693cdbf3679b3f777cb8e95362ce2b4f079188ad5c57bb2e34d7888ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc9730099a79c697fedd73832eacdad4e0e4da96752bcb30b6e5d300a115a7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57d3035e0fb8add089f2ffd8b224935cddef130a18a5b5ad07e337120bfad37d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e33754a425f210f75712f20cdd11cb962044221226a5a2f3f346a18c2b4cd235"
    sha256 cellar: :any_skip_relocation, ventura:       "ae925aa73e2c8c701be15a5e9ad83f5748b191f669af7efaa4eb2a255b71c455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ed63d710d854c64df71b848fed29f4998f68e43ce6d442f7f7c41514f6842c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfb6f9993f6cffa1e80cb8843e149644d8e4b564169d47a6775ce82a84695c4"
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
