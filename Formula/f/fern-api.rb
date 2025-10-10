class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.88.1.tgz"
  sha256 "3c669d4edd212b373202ff2e519cffd98a7a233f918a38d67e99a94503cd7c66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6a28c26ef0d7db02bb733505abe25f15567a8cd201bc6eae0963b8999fedd08"
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
