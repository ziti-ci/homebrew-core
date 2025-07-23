class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.28.tgz"
  sha256 "263c8d897af2da8759d1a288930584aff9cb2d18157a9c95e44602e4fd8253cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6be95bd931965cfe9a16b50cad3244078f064dded11b02c9b2f6fad13471af9b"
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
