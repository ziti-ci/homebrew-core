class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.88.3.tgz"
  sha256 "f9fb3fd436fd2a83da5cc56279fea91a34251e6fe85f8be72c5ea0f64e86b057"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d755be04957a2d66f165ca930119d2047086aaeade19fdb41211e90692d4d048"
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
