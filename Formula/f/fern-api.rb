class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.23.tgz"
  sha256 "0a4c6dd9ea315fbe4aedd991bd60a6393e29cc94ba26b4095c24f803308a1db9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb2882e8c8c4c8343a03cdce594a8f888167193612d5f8d9b3bc93e886ad6cbf"
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
