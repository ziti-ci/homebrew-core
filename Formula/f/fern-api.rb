class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.28.tgz"
  sha256 "6e626f5b86052f18e4a149c0cea0aa81a9f217ac5fc7a82428c17901ca08d21e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "874f81e49cad383bda4dad1e734bed895982b64882baca7263646d0d966f75af"
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
