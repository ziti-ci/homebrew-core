class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.78.6.tgz"
  sha256 "2fa565908afa6138902017df90162ffad07ba546defae8135c8c284d5bf93334"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8727933bbdf074e08c29fd2cea0d457ba7a6fe48203f127e5fc5f7686010dad"
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
