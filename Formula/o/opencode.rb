class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.3.tgz"
  sha256 "79e22652542054e1db6697279cc058e3b298a1901780f944dd4d95639de20664"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0063728bddde5f2a212b9ae3e04b9ad1ae8be88770ff466d1d6c7bdd2667d54a"
    sha256                               arm64_sequoia: "0063728bddde5f2a212b9ae3e04b9ad1ae8be88770ff466d1d6c7bdd2667d54a"
    sha256                               arm64_sonoma:  "0063728bddde5f2a212b9ae3e04b9ad1ae8be88770ff466d1d6c7bdd2667d54a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd176f92f2bfb336af8d359149a6d325a0dfcb594d5b646df1b0e12edd92f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030b9539fb1d877e48f66df2d33d0e1e11868ef54fdb03731bfc35f9fad4b77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f22be225d4a92f13f5f4944e31a96adbd3ef3b6a2028b286cf7116c3fc4fe6"
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
