class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.76.1.tgz"
  sha256 "ee55bebdc3c435e604bb1cab788960d3d3ec7ac91ade74515945f7fc4ca1c2f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dede20900dbb5bccf2f0e2173068588de193c82488d02dc3a6e9097859f45a2"
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
