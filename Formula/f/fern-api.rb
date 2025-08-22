class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.23.tgz"
  sha256 "cf6f4dd77e8ce3b7af1a5a0cdb4b1e008b6bf6e7916ff4efef9d6feefb3d6044"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27b17ec8ae75f44d3354048dd7a61f9ea8cf84a9fc085c40163edf459fb9ab4d"
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
