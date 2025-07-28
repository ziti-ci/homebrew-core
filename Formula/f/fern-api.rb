class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.34.tgz"
  sha256 "0f4c134395fb284cb580d8e64442a2fdaba30f5ac2ca4875eaf54d5dcfa49f0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "300315fa6436e4ff62ae2be041f7a82ae554ca232a39f1b1dca79913e18b9837"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
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
