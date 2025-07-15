class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.15.tgz"
  sha256 "f93cb819007fa5b64045d7a41c04beb086c79b245ea80efb2d84284de5b67018"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56f14b94ed0c8a849496fd41994b04e73b7baaf15c9f298b6d7c74c58eee76b0"
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
