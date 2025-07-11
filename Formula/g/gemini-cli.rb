class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.11.tgz"
  sha256 "1cee4750c7f3dc1ebaace75b93b577de21087b470af66411bb38a90f87b5309e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1bc89a7ad503c12f0cda4fa5ec584da72e14c35f28f6dda8c0ab4c0f6b0be28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1bc89a7ad503c12f0cda4fa5ec584da72e14c35f28f6dda8c0ab4c0f6b0be28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1bc89a7ad503c12f0cda4fa5ec584da72e14c35f28f6dda8c0ab4c0f6b0be28"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e94e1e36d56f06fabd21b1a8686994b0a86d81adfac6da927b711a20656c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "30e94e1e36d56f06fabd21b1a8686994b0a86d81adfac6da927b711a20656c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1bc89a7ad503c12f0cda4fa5ec584da72e14c35f28f6dda8c0ab4c0f6b0be28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1bc89a7ad503c12f0cda4fa5ec584da72e14c35f28f6dda8c0ab4c0f6b0be28"
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
