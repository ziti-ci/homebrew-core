class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.33.tgz"
  sha256 "c74205dbad2868f96f62032b72a999719bd58f40fa7f44e56c6993289fbdc0e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76c333f68d527aa964612c72d5047401f623ed6490aa680bef12bd06901a3166"
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
