class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.30.tgz"
  sha256 "63c3aefb7f92ecdf7e40cd9e2aa6be4f913ca3cfcc5d7763c8ab3c995aaf5f1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d6826abf0a1aca8c7608ea075ff2c2cd4f67925e1e54018df25d31149a7efb6"
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
