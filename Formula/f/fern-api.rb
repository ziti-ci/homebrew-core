class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.27.tgz"
  sha256 "6bfa4695460ca656ff194536d2be02d36061b9a2168f5d720bc19ae42c3a22e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1217ee6d8e20ae22d0eddc40db80019f06611877e64327d2be75b15cd48c582d"
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
