class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.13.7.tgz"
  sha256 "329edd3e3ecf592967a501d36e0e7bd74c57b2c17957ec5373ef7fed595e1b1e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "36f3e14627f9707d67bab56ad834140a3b2ef96b97529b8ba9f121717d78c926"
    sha256                               arm64_sequoia: "36f3e14627f9707d67bab56ad834140a3b2ef96b97529b8ba9f121717d78c926"
    sha256                               arm64_sonoma:  "36f3e14627f9707d67bab56ad834140a3b2ef96b97529b8ba9f121717d78c926"
    sha256 cellar: :any_skip_relocation, sonoma:        "46a1bb173169fa8d7ba65b8e18994b2ed5679d7c911109beac8aca138b54c3d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "134d135e4ff9360677f0e3c0a91ec8e619683a625d6a8f71426061ed04e41515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c04eef9c3e6254b0949cc3c09ddbd48c2db712ce0dd8df66c771fe125815ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
