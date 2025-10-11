class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.88.4.tgz"
  sha256 "deb822366cce4be6f3748dc81c190117169037f160dbb0af356d2d89039b5f8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2dc1720241dfe473ccff1d08d44012856818a144e4bfae467acdd0704177dd08"
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
