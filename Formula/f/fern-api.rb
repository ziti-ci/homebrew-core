class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.73.0.tgz"
  sha256 "361291dd85cb874824de032d16d2f6f0fc57c4ae2cce8ecae27dcc4a467ef01b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86ed0c027d6e2b99353daf6fba20b7d22149de9d4d1e1a68793295830c1f6ef7"
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
