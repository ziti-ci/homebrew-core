class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.75.0.tgz"
  sha256 "2b1347ad0e1e4245333fb284393cf2490f3edd16b59411e9290a5d56d4c637d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63af93d3bf4beb12d9c3997b56ef6068a2fb2e89129970cd82a7a91ee72bc5c0"
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
