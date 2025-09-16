class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.5.tgz"
  sha256 "a3c276c9a683d77c1e1cab3698328d9c8e6221c8902a70a02acc99dd0e0ec2af"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "da6994e9eff15bd19a253fad73a93e7c11c646c574a0578e528ce9910b827863"
    sha256                               arm64_sequoia: "da6994e9eff15bd19a253fad73a93e7c11c646c574a0578e528ce9910b827863"
    sha256                               arm64_sonoma:  "da6994e9eff15bd19a253fad73a93e7c11c646c574a0578e528ce9910b827863"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c8490906a39b343f0b59bbaefea17c477af525e7cec83549c88ff4dcbf9ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f12aa4d0fc4308199659037766ffca0af63c9adbbe9cea078339c6cc550d258"
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
