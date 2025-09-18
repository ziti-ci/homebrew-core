class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.5.4.tgz"
  sha256 "f47568c04864e9097069d106f5fde74dec31d1bcac4bf11e25a96b37f123383f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "517b5dcf7da38acfa1d97d6f973d7c0af78a2113349d071853b26cdea71f4110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "517b5dcf7da38acfa1d97d6f973d7c0af78a2113349d071853b26cdea71f4110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "517b5dcf7da38acfa1d97d6f973d7c0af78a2113349d071853b26cdea71f4110"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8888ac6ce5391e40d76f7a5c6d9b5a15437849eb257e5cb4630af4337f6725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d8888ac6ce5391e40d76f7a5c6d9b5a15437849eb257e5cb4630af4337f6725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d8888ac6ce5391e40d76f7a5c6d9b5a15437849eb257e5cb4630af4337f6725"
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
