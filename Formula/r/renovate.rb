class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.72.0.tgz"
  sha256 "37bf735ef35ae1ab1e1a9345bc931a6b505c9f151207b19b08afc57256c273bc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386c74552e39b0e5122228c59f00c16fcee86a210a9559c0cf23dbdef84f08c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7919681eae9dbc18fa9521b60581dd965dd52799eeecbe6a8b9b4c0a74977809"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a4b13c67df21ac28444df89be7e636cd553d52ea1e49acc1f7bf9f6ca230631"
    sha256 cellar: :any_skip_relocation, sonoma:        "8705988c97259981a9173281ab7abf503c0c71d7db15e79171ab3d7baf4fefe3"
    sha256 cellar: :any_skip_relocation, ventura:       "b3a95c5701ebc200dae4d82bbdc8c673c20ba3187a6117de830d617aeb376de0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ca73fff4cc33f1b8404c9ede7c87e2f93a7775d88e408a2a886281b1afac00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b57286490a3e769ca3db2853f80dd32fb86286b0b658759c54b1d5d795dab9"
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
