class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.6.tgz"
  sha256 "db7b05c1d9f27a9835bfec6ad20ae47df41e1b3934191f2e144429b515b09085"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b54459b662e0789e5ad086c5948e543a77b658a99b1535cc2bab1b081638e9e5"
    sha256                               arm64_sequoia: "b54459b662e0789e5ad086c5948e543a77b658a99b1535cc2bab1b081638e9e5"
    sha256                               arm64_sonoma:  "b54459b662e0789e5ad086c5948e543a77b658a99b1535cc2bab1b081638e9e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "92cb6f3e68c20a6cf8c650e7a2f955dc5f0df2c36427eb6310436b47ac2b05ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d03bf19172cb8a6ddc833e900101156cffa966ecf160a35607a5749c192cc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75533717df094be098a45ed6e359c8db751ff9cb36f6bc0f5cc8d8a7d0e08c44"
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
