class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.70.1.tgz"
  sha256 "be9d784aed8359e54d8945fe387532da7135f2da471e0f4a699a40a05122c6f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85efa781759bd489e6039c3be831f339b639189260fcf385fbb4ddc3f12c9ed0"
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
