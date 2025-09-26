class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.82.2.tgz"
  sha256 "8302f3d34715db3a9fc1993257ff1c90369d95198d66d6a312eb9a029e7c871a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b12b9c36f306fb44681f0735cd6027b22d83a7a62985b16da90388a48fa57c5"
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
