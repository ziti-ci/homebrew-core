class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.77.4.tgz"
  sha256 "9407149712722b65a8767bd3a4bfee5e05d26baf77b47c71e402d2fbc19d2f57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d1277bf63d4d4e3606237138bde475b8d2b9e3d8802c70c473a18cff85ca3c5d"
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
