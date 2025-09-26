class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.82.3.tgz"
  sha256 "c4a01f0d562e64033dde7ea1da047afe78d4efe5b46ae0cbf4d1b4af0f81853b"
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
