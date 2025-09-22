class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.124.0.tgz"
  sha256 "b56e59a5a7ee437f30818338d63257ebc6a2591bd89402b1923e348fff055615"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeb86164429acf711323298e0b6d800c982c22d4d282e3345a538ba2c196ceb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2c13bd1d5cb617b3a6081551f0e7dd20a31225b0920899799c6f919c4f3e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cddb1da8d0ae83b2ae2bf52c16ff0e73a794c6f9cf0149668e9b0338059562bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "99074a26410f2cc9c491fee593a1ece0ad190ee6d47a2e73c6e1d1daa22384f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b462c52a53c162846cb2a6ff88c8c7ea5ab6a400fa9fa3df8a3bbe2adb116f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ff91e8a5792c9607ac4ab770770e84b8ad3a15d4a5e07ffef3bdd098bf51a7"
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
