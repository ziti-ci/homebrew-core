class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.69.2.tgz"
  sha256 "8d7f7c7c242a85f614eee29152b90af4b9ad6bae594bbc21d7b5032b530062df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bca88838802fa8271aadabb7a06d4a6b8c38f8abee5d5106238320c3b63fb9d8"
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
