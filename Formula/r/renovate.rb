class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.148.0.tgz"
  sha256 "63a140c442cd9dd5ed65ca4ff575f21bed799142cc9a12a7f02686b289a1a386"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2ccbf433121c3198d22c89bd07d10c999535521c7d31ddc5e76850c491b0091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "895709ef4e76008557d7f62d0fcc0a4229f6f35e1278793618dc52e44cb98fa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e093875c768c605e49e2c5f6a8694c2ac3664b513339362fe02c5b7cdd0b0067"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd1d3dc96b48636d3198ded63a395a9b12a0e89a259a0feb3eecf6f36c597bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2022a08d20962c2acdd3b4b4164523ecb8a98255c16edde123dbe020b64557da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce22f719f77851c4543fcdea30f32967f9f2491e86a6a965fe8d1f811de2e74"
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
