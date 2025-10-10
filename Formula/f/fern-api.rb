class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.86.2.tgz"
  sha256 "986c73727c7e853fb1269c150dacb065b8ecf4e33aaaf9e85ca7ae6d377a34b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa92aee40898aee1a24f9dd0be0059b30d491183789149941fb106ae9a9868f3"
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
