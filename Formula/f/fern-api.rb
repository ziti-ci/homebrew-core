class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.77.1.tgz"
  sha256 "aa1304cb3dd44a67f9def38e092c5bb1f65598c57a18d01645ed5058a6a36d12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8c975aaaf857a43178eede75be617f5234887bbb74f28da43cd3665cce53231"
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
