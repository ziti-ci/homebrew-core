class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.19.tgz"
  sha256 "071303a40021d9aa51b6ba10cd15d1966c4b5299a0c1379c0b3f21e4ca969010"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e822bccf49b993e9e1bf346cbf288525f3633823a6deab73d5c3dbdf6b15a8af"
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
