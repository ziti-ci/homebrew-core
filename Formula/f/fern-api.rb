class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.86.0.tgz"
  sha256 "f8c2606036cfa5742160caa864b6e6e84505d03ce50ce1f28573734576e4ad93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48d44df3c506ea0f2552858224ad94f832e84ae9a991ceb43be970720a053f0a"
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
