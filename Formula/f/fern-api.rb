class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.84.6.tgz"
  sha256 "d803394489182963249c3943f39d467a79db41a9b0fed17e73714ac4630d48d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8831e3d4fdf4a6f417265cd618c9c4fcce552b7deb041738af1918ebc37d054"
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
