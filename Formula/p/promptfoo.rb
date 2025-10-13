class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.15.tgz"
  sha256 "719646d44c2b16b82a061eb9c1933458dade4558a1e163ef56aadde4d3b747ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbbd653c922d48a6de619acd0cb82501c7d52c5ed6659f37c446eaa87699f2c6"
    sha256 cellar: :any,                 arm64_sequoia: "46022513291688130a3d5b36a845e5bbcc522a60633e8053a1250b5a3e621f9f"
    sha256 cellar: :any,                 arm64_sonoma:  "6caffd4f513671b088435bfd37030e14746e919b5c7962026b9b4fabcdc18fcc"
    sha256 cellar: :any,                 sonoma:        "d449260617787f6c04bbcdd330b2950415c4123f6e3a65b3fd23cb27c76ebe08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac8b46b349f8d03956d6141f027a4c89dd694782cd5c2ad6d12c9915f2beae2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6171c505487879e7dc07177b9c43a9434fc57466ce90ae13a5f49376ef75b3e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
