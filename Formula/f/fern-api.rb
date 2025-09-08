class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.71.1.tgz"
  sha256 "fa5a797c66cd3d2b956b162a4d896a1bb61b511437576ace632930130fad33dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac564c2bef96b41866644cbe3a736e9609ad7a714d589cba1c36fec8adcc94af"
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
