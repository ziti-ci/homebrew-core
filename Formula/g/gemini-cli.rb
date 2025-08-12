class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.19.tgz"
  sha256 "be0149bf0808d0ff3f6c8268bda0e4f083aab53f8c8d62d06f89cf15799c2532"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e2e2e9c050f3f5452cbc3af7aa5c05e1984aaae97d829bd9de12f1688e8388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19e2e2e9c050f3f5452cbc3af7aa5c05e1984aaae97d829bd9de12f1688e8388"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19e2e2e9c050f3f5452cbc3af7aa5c05e1984aaae97d829bd9de12f1688e8388"
    sha256 cellar: :any_skip_relocation, sonoma:        "aad9640350128a6e9c825eec1b69884f41e6a35f67ec07994f95a05e4bde974a"
    sha256 cellar: :any_skip_relocation, ventura:       "aad9640350128a6e9c825eec1b69884f41e6a35f67ec07994f95a05e4bde974a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e2e2e9c050f3f5452cbc3af7aa5c05e1984aaae97d829bd9de12f1688e8388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e2e2e9c050f3f5452cbc3af7aa5c05e1984aaae97d829bd9de12f1688e8388"
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
