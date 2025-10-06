class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.85.0.tgz"
  sha256 "424706fad23b2f71dfcfac35719bf3732cd5e4791b3a515cecbcaa003a1c8a21"
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
