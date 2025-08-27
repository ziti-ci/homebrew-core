class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.2.0.tgz"
  sha256 "e1dfacc40cbf8bf14901261376ce4734667decbb809d90fd78afa1daa5711152"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "05c2f09cc699d7f4095968c7ddec84dd3d94f6a72d5d2089332b9919a9135671"
    sha256                               arm64_sonoma:  "172837a798fdd4f0bb0035edb9c12eb8f34f10f19f1d894e3bc15e08680d29ae"
    sha256                               arm64_ventura: "cee8070f9aa082a547b0b6d8be3ac25fd95f441722b9ac2305cbd88b28013b83"
    sha256                               sonoma:        "5bd93aa38375e81ac530f8823f755b0bff6ef0de31a24a5610e6c9c488d30ca2"
    sha256                               ventura:       "4df6a9852b01fda0794f6210cf926be20585fbc7b2cfe44484bc36c0254a061b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5e1adf90984bb586290a6cc6d193034cad043b99db25b60ff4542bcc791d3d"
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
