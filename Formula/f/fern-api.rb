class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.25.tgz"
  sha256 "8a6628ebb9f0f26ede97ed8a00a4d995edb64537604d76fd4dc022324fc6b415"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f1321a22206a61a42a76840faf7fea3df08d432cc26513be24407db2701b05d"
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
