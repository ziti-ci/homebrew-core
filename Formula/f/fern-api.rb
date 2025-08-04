class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.45.tgz"
  sha256 "ff3057d3ea8c79b776f5e958aa276b76dab3ad5ef15addd32a201440ea4fedc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb9a7b1b594fa81fce8de94a564f3077402761e3dde59360150069905d4c07db"
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
