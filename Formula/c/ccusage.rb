class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.7.1.tgz"
  sha256 "7101ac12ae8f0258a69c765f292d354dc398d9964a9244e6f677d7d245a83b6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80c8d61b53aa4d93cc0d58979ababea5d63230e31c963a55d51881485846a9b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c8d61b53aa4d93cc0d58979ababea5d63230e31c963a55d51881485846a9b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80c8d61b53aa4d93cc0d58979ababea5d63230e31c963a55d51881485846a9b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d952e7c357cad6e7abf137fc3d4cefe3a2d737053bf0b4887bf0fcf61d37d1"
    sha256 cellar: :any_skip_relocation, ventura:       "69d952e7c357cad6e7abf137fc3d4cefe3a2d737053bf0b4887bf0fcf61d37d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c8d61b53aa4d93cc0d58979ababea5d63230e31c963a55d51881485846a9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c8d61b53aa4d93cc0d58979ababea5d63230e31c963a55d51881485846a9b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
