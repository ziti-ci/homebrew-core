class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.47.tgz"
  sha256 "f3f9347e4ed9d939a865190650b294271e09415d20018b7e7e76e0d6329c7414"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d852178914af1b06988bdd719cbacc5763d3bb9fbe770c74762e0213db5d67c"
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
