class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.74.1.tgz"
  sha256 "97ac22e6f34b916835b5821e962497b0eebf19b9f364a9a1b66aa64bf6da298e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "729a1593bb230ceeb6ec5caa78dc08c1a81544859e3eb9bfdab5c96420fd128d"
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
