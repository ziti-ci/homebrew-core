class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.35.tgz"
  sha256 "f44be3b040d828b415e012694986982253064c0c97063f79cc18c03916e8c662"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ca7bc385776c8b3e22ba66abf9bd464207839d55bd18691e2cdb6e35752b994"
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
