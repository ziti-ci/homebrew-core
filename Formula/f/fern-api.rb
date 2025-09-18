class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.77.8.tgz"
  sha256 "f2c4f26ef6e2cb2c08b252d7c725778c39712b43776c36f1a593a199ec42db1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e9ffc8c1bde90b909e230307f3e7e8004b7d6e52808f7175263777a97862383"
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
