class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.11.tgz"
  sha256 "455542e9c6ff18624e2ce91aee52287da4434fb4fdd3d7918f5ea652a679f59b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c138875daa6955077f34a4f23d843d7ca1346a7bbe0031f5d00faee95e21de4c"
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
