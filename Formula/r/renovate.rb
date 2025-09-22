class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.123.0.tgz"
  sha256 "d15191bcb067d1fae2a4f6632ae89d444747afc75f4c2b12a263374504a3b2b9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54f98fe946ad59bb460481a2d39eb7b84b7d32a8efd4711140ccabb49b05c07d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3400f4bb1d169c92bbf14b6df64a3365dab0c721f5e6157b238ecc1436b288dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f1da41de86d30a779fc0b1305c270463d330ca6ce49c21689873d0b84e92f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aaf063ec8c711a3ecbe24bc658d42d4a0bbb625fedd203c38865e1c21182de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab092569e77955168e17964e9361cf32fcb0004042c2990f88536d812127f876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963fcb10fe263052a90b8d14e78e5ddd89c6d59dc5e6ee8bf2260f1dc9c0239c"
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
