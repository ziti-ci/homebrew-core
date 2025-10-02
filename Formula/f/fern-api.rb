class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.84.4.tgz"
  sha256 "6acd390498029bcde8647ceb4dc4399e5187139cbffc824fe3c864dbf99cb823"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07326300892f7df4764e36e72334a868f476db4ceb8c53c9da839e7ec33f0016"
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
