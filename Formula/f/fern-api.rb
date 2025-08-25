class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.24.tgz"
  sha256 "5141d7b94caea204c9b9ea3917ee1c8f2a2721cafdf90356f91ba5d7cff67fb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df0b0328a107b37dbdb819a852e94138cdf096a3786b7228a29556d0eb38d0d8"
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
