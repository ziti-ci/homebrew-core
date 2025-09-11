class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.76.0.tgz"
  sha256 "2a21af9039b4563cd218a6c1e9b2ec42ebe4f703c8eae39bd64479a5cca82065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c60e90d3cbdf6ec926d73ea6c68f4017bc890d9f8881dd5d9ac891c0048be7d"
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
