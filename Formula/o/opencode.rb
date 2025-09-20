class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.10.3.tgz"
  sha256 "250310735f8908b96a2ceb09b92a8206222872a1f63ef9c311774bb7d79351f1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9a480117d29144343de2db50959e5f7015205529003f16401247878021b23abd"
    sha256                               arm64_sequoia: "9a480117d29144343de2db50959e5f7015205529003f16401247878021b23abd"
    sha256                               arm64_sonoma:  "9a480117d29144343de2db50959e5f7015205529003f16401247878021b23abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f33c283061cbcd0d3db4a34d4e23b5cb3d8f32c473202d825d73c0ba2d1b1eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94723eb7f265bc52f565ba9ab2df331e1712bef1e3e69a090881686ba84c6bd2"
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
