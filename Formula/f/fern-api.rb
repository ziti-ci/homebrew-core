class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.84.9.tgz"
  sha256 "4cddc0f530ac09ad536fc7c663fba6264575e92e544f5e69ecc9f1b73e066f13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf4d782129ed43c12f1f2da1efe69d05313f502fe0e180253e2277789b5b3927"
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
