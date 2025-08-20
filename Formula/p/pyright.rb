class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.404.tgz"
  sha256 "72347dae19755c75304ac68aacef5a32b5cad0360742d45690786ac18448612f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6a4eb7ee5aacaecbe24647bcc5752c22eb17ee895f98bc275f65ff2bf77300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c6a4eb7ee5aacaecbe24647bcc5752c22eb17ee895f98bc275f65ff2bf77300"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c6a4eb7ee5aacaecbe24647bcc5752c22eb17ee895f98bc275f65ff2bf77300"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f353845a64cb1854ce8fa0a69e45fed912482dcf1522078ea9fd5584fac2a37"
    sha256 cellar: :any_skip_relocation, ventura:       "0f353845a64cb1854ce8fa0a69e45fed912482dcf1522078ea9fd5584fac2a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c6a4eb7ee5aacaecbe24647bcc5752c22eb17ee895f98bc275f65ff2bf77300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6a4eb7ee5aacaecbe24647bcc5752c22eb17ee895f98bc275f65ff2bf77300"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
