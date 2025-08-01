class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.41.tgz"
  sha256 "ac31701b65f9eaea8abf3b7042c8378406f4b45eb93046a15812efbcfae4334f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eac00c8011cf713a0b2105f671d5153678d6a535f9b7915e3463104157b8f148"
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
