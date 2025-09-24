class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.80.1.tgz"
  sha256 "f94a8ffb02260ac50fdcfad66d41473727be95a43f7f015107661ac486821912"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c064ed03d7101bf22db5108b534752b45fc0243c6e25274b9ff0fb52ebc873e"
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
