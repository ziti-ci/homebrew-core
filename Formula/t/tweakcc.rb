class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.6.0.tgz"
  sha256 "e87e4a186b669af125d0f9993cbe98f8bf639f1268a70a233236de68fbcfd225"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c98f320e4aa7fb4d301a0edef0add6bcab604d8668e7fac89d8eb1d2cdff450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c98f320e4aa7fb4d301a0edef0add6bcab604d8668e7fac89d8eb1d2cdff450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c98f320e4aa7fb4d301a0edef0add6bcab604d8668e7fac89d8eb1d2cdff450"
    sha256 cellar: :any_skip_relocation, sonoma:        "18caf38cd689cc6880d868fe8df75d2216b7985cf91e0ba6acdb9cbb43be19bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18caf38cd689cc6880d868fe8df75d2216b7985cf91e0ba6acdb9cbb43be19bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18caf38cd689cc6880d868fe8df75d2216b7985cf91e0ba6acdb9cbb43be19bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
