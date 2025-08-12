class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.66.0.tgz"
  sha256 "9f4f313e305fe158fd14eb8fcd09907bbc6dd4b11abf60fee4284aa0f25ae57c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14ecfdc116cd4d5dddec0480e6fe6348ee132b1ff29fc23bce8008ac336a00a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d70109155024e1c5a1c15397cd8e55e538f645dcab52714b104674edac83baab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdff36c16c5c90b0f64249a039f324cf1e51b7cdf9a25901952f2cd3777a0d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebdc22d550f5e3c064023983c2c9273f0fd315cc4b92af48866c6e2513993531"
    sha256 cellar: :any_skip_relocation, ventura:       "0b1065f8e3eba72ee7769d3b321f73e0cf9ff94c25426f1b1adc6acc1ee90fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c92bc6516550db476f2fbc5a62982d823c62d37d9701ca57723ed523db0cbbe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6ab53f98f9ac569b5f6d6026f2469ef2eab327fb4ff20a424e3cc09679ea8b"
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
