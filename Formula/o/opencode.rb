class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.13.0.tgz"
  sha256 "c800c06b60475cf10293f94f1d3d35258291287809b73910b4a2e65aa1868bcb"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6defed01a8b34911b2c337cb24126a541077c5a5e7dd86cd0cb72f83174edae2"
    sha256                               arm64_sequoia: "6defed01a8b34911b2c337cb24126a541077c5a5e7dd86cd0cb72f83174edae2"
    sha256                               arm64_sonoma:  "6defed01a8b34911b2c337cb24126a541077c5a5e7dd86cd0cb72f83174edae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "576d60725a0faa0b187a3932478587edb73621a377a861891d79e07a28968beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "828923b97228c2a610b7e0d8c847d3ed663b39cc55db329264b859a109955209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfb9d369316761167529d35e4b69fc970a4f4a416c23c4427bb8d56479fb052"
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
