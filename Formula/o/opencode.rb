class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.2.tgz"
  sha256 "dac71ae2435f4f8905a2c6cc61bcca0976bffc8a71bf5f2979010523c5c0da8e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "767d47912f25c33064bbcd14bd2cef2540eb7a21e05007d82826ab720a00f04e"
    sha256                               arm64_sequoia: "767d47912f25c33064bbcd14bd2cef2540eb7a21e05007d82826ab720a00f04e"
    sha256                               arm64_sonoma:  "767d47912f25c33064bbcd14bd2cef2540eb7a21e05007d82826ab720a00f04e"
    sha256 cellar: :any_skip_relocation, sonoma:        "57b7604ce4ad397a40c8cdafce616e9ba35252d92460446eee3077c09826486f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cce99342ac9d16c65a0ba0757cb819b22e79ca46a8b570d99fb25f36aa77cf0"
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
