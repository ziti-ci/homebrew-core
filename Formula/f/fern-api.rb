class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.70.0.tgz"
  sha256 "bbcfba3a173b8a331a6f890df5cb383f66aabf0e880c74b27a88d2275e9da81c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4fb80887a6f6fa2bdb96fc25b003cc6186f1f0cddc9cc8dffb485b1e89636a2f"
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
