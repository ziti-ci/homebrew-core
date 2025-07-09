class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.5.tgz"
  sha256 "c63091f426990a347b2a4cd0fb6b24c1eee8e58a61aa100132cbe5ece3a839ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51a96736f5fb7678f2a116d9bb726e601b34ffc674c1312f88f9524d8d94cb57"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
