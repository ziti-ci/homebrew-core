class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.0.tgz"
  sha256 "03a8b91a89a7a3f98f02aacf5416c5e6cee1cb5308c037e597d1873239c53cfe"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "eb95cac38b1351bc5da9941c33c9457cc5b2e1567eff9f63338388d33ee7e1ae"
    sha256                               arm64_sequoia: "eb95cac38b1351bc5da9941c33c9457cc5b2e1567eff9f63338388d33ee7e1ae"
    sha256                               arm64_sonoma:  "eb95cac38b1351bc5da9941c33c9457cc5b2e1567eff9f63338388d33ee7e1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "645461c7438926398916ac5c6ec3ca6b1ea0d22f96c87d12845f904b0a5b87f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376377ffa0270852eab08282c12de7c7c77922ca2fe012942c266895b770e19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2872f341abb04ca37aba7ba2b4c0d90a2c57affc4feefbbf49dbba0414acce62"
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
