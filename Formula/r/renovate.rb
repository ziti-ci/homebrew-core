class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.100.0.tgz"
  sha256 "4adf0fd70198b06bc639f490fec883b7206a1743f536cc15598a599512ffd052"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9def7ef435f1f6fb0f82bb945ce84db0310baea27aca1a16cf4e645998280342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f24b3414c62584c66f0dbde8d540cc3b26d6da2b3295b904c1956fce40a742c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1441015381b97a1f3ab694e6394a8752f340e6ca6743629bc69d5797edc250a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0938bf623b0f4d0d9ec1718755435b9e9aabda127b43544b1b3548e27484755"
    sha256 cellar: :any_skip_relocation, ventura:       "776a47e874e8ca9421cda5bc8863b99d0699b42ee85db64fff3bb8b84c953740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84544a062545b1a53670a9adf58b9bd986c447e27b42a4a86c29ebe906a93fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995da98a04ff55143df3ca0ba23d292fe1c4f3e23f7d6f21ff8a16b4aa9c3550"
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
