class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.77.3.tgz"
  sha256 "55227d2cce4ffe554b87893af8549b7fc0239870ada76dc43c3cc84a41f06372"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac1ef1bf32dedba12b51133dce8f27b006d61f48e309f73063120cd779d59d22"
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
