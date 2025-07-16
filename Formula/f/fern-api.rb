class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.17.tgz"
  sha256 "e7d7762784ae260279362627af2cacf900cb0bb6301e8da874b14ca548c384ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df9256dd0e09344aab338b05604a11537a59c623dc04518e66d2e8e84bccd698"
  end

  depends_on "node"

  def install
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
