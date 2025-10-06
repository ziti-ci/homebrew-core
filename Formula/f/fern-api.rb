class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.84.10.tgz"
  sha256 "c45c5f679b228e2803e5ec27b61254340307ab5474547724304b0581949df763"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8932d4803d8d3c3776f90d4d1116f0803b4c46251ba9ecdb12e7e94b8b7fefe"
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
