class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.0.tgz"
  sha256 "915a8f8c3482e79f9c7a62845da5cbbf7ce751359c62f337bd9cb8b8d3864b26"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3bdf188b7792822ef31434700e366aacc23b76db52f10d6d2945a90d7c677432"
    sha256                               arm64_sequoia: "3bdf188b7792822ef31434700e366aacc23b76db52f10d6d2945a90d7c677432"
    sha256                               arm64_sonoma:  "3bdf188b7792822ef31434700e366aacc23b76db52f10d6d2945a90d7c677432"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ca0a8dafe72537420364436677a539a2801874b91db853337be3cda5fc352f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272aaddc0c0bd3f92664c8e2f9e8e27d6514b0ffc2fda24255a2d298908ee021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01b2432e5f0c0a39cafa28816c4001a33933c528488d3b8e4c9a37181ecf989"
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
