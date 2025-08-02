class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.44.tgz"
  sha256 "060e05831f7d0675c41423777fc344cee8b5aa895b759b31de5613e56e4e1664"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca3312081ba4b2a42e8ff0fc2f107435945d5df0002beee327904d0f6fc19311"
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
