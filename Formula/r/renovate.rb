class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.137.0.tgz"
  sha256 "608106893129138f5d6627872aab4db843473cb31380686c181579e8b880e165"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f38ed37735061935a6481155041a95ffa4d98a8fa32b51086964228c39cc644f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766f7a903641bd020c3583f2acaa56da909bf0fdcf48fd077de70ffa9ce169f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc2e36d46775b820d077166fc08afb32b503c47cc676de26c51212f1ac7bcec"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c8fdb6b26daaff55dadc33b11bab373b55999ac5f1ed0a0ad302ee9864e1697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca39a1611cc0d81c2b65146b80a11e310148101c4ca129eb809dae34b0ad8ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c8d65e0080a2a00e1599e805e7c43ed40c7373e2657a80c658ff02e8e4201b"
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
