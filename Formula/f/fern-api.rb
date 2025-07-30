class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.38.tgz"
  sha256 "bf853f18a362b22bf376bccd44e2c346198758a74aebfd3ca5d67b5076acbdb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f757cc852a11c71a629f83c018cc034ea97e24b6aa08a47b5934c3ca9d8f3b68"
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
