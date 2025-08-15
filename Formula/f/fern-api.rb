class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.16.tgz"
  sha256 "333c0b821a896ce2ebf3cf529abb63ba430a5fd07cfd243c85e293248260d473"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a3916efac48260a70c37859ca5ad0e338250450a78fcd54f6e03a26ff0fb561"
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
