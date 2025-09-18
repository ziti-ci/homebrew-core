class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.77.6.tgz"
  sha256 "053000ac3d86fff89fab5175d5850ae2a6e92cf942b84c7b3560b96715aa5adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dcf3c736708aec7d7ef2768dde12f834cc9c52e3f97fce6936300ae799b87456"
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
