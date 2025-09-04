class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.70.2.tgz"
  sha256 "af7e2053dde5ad95834deef3171bdb920a9db361c3e661abc0fc6aa662f2b5dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7765fb478ef70254f0795f248c835b4de78743118c79e2aa5cd54fc9e191f4a9"
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
