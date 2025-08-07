class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.56.0.tgz"
  sha256 "2e8c9a82f73e79709e7197cd407d67666a04b88f2fc385da7a558b5fe4c52f26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f2f161e6a795d0d90fb7e95782c67d4cdaae83c963705f83a0346f03dd30e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b146892870c63db4e90768557a7dc5d8b3bf75af8e058a7ca06251b2bb322dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "525cf20c49992e1312a86ae48573c76040920fe5db5377a65d6e9b1cf544f27a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a16c6107d6b67ab91fa0ad96bc771c2d4079206aab72b4e65e4899ef77b7b4"
    sha256 cellar: :any_skip_relocation, ventura:       "4f7910f9a11d5648be9aadb93da63250bec4e0103142dd0c37cf8787e6b333d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b1da7fe4e46eaf97c1d7ea4a7be1b96ade692d3cc07b0c8ea8cf603e1588ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b5b5d549ddac77f86bcea0dba1c64c39e36e8d868e2f3b0fd1d16a4bd1545f"
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
