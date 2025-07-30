class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.37.tgz"
  sha256 "d0f5cd0bebe4b58bfff07d26ac6ce6477b32a91a2d2db4c158f11c2eb6139e14"
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
