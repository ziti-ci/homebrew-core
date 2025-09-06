class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.3.4.tgz"
  sha256 "495f6c496afc358f8f6bdec791b5cde1f99ef7901319798f2da2c37562ded260"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "07b934ae3f9997630cd18598b924bd55cd7d015056a4c789a239afa096b1a034"
    sha256                               arm64_sonoma:  "8ae4f8f7455f8b19735a4cffdded66ac96779f00060904c7e7b90c4601fec192"
    sha256                               arm64_ventura: "56a274c0cc80692161c1cec2e026233968ba04bb8095b30efb9ffb64562267e6"
    sha256                               sonoma:        "c23458409f7873cff0d55c06923432f0e25b467cc6f9c2a602f05cbd89c8e5a6"
    sha256                               ventura:       "f8280c6ee7ae2f0bd5fbb4b20aac6e3b2d903ed0d5d2c46b5825f3722656e7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "830ec6d2331c873e9b2a3e4b7e24b065e1e7e02974f47ffd00dfd62b90f89ef6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
