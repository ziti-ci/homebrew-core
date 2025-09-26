class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.12.1.tgz"
  sha256 "b3f542c7a0b47589627f6172236a73f4b8e379cda8b05c8484cb2ae22b7498df"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "af1e512c2cac0dbd8b2f1f2830b9635e357278c6430829a928266eed585b2712"
    sha256                               arm64_sequoia: "af1e512c2cac0dbd8b2f1f2830b9635e357278c6430829a928266eed585b2712"
    sha256                               arm64_sonoma:  "af1e512c2cac0dbd8b2f1f2830b9635e357278c6430829a928266eed585b2712"
    sha256 cellar: :any_skip_relocation, sonoma:        "466a3fbae3532de15980dd30e4e443ba7ecde9cdd06a6fcc22bdd6e7e3fc39c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91136fe29ace110e57b01605937a9cb15a0465307d9e5d5bc8f8b6bc1b51c429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b072c8ee81e1fadbe8062869eef6f63fd939e62429523f20f9a1e2a0cdd686"
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
