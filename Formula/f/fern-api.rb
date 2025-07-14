class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.12.tgz"
  sha256 "fc568784ad09eda4b08ae1d6d5b17607f0fd781e1a6a4d3cd31cfbf03af6bf0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5fd5bd28d956f92556146e1ccaa1b328de3cb403c003b9fcfb2badfaf0b37ae"
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
