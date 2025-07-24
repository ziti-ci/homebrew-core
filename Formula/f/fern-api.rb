class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.29.tgz"
  sha256 "ca5a06822ae4bf00a86175f56d8eb88fc1310c0382e9840e2a2aedd0ddc521e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2443604bc6b3c2178b86e97170d4147c87019ca0faa8a51632b79d266a2d962"
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
