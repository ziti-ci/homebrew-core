class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.7.tgz"
  sha256 "302d6088283fff1a3591079f51de663c9dad9428adeaed5cfb5bf2928b6f6421"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcb8d7b636f37abbb81933bb3e2318ba68a65ab7b07dec84f48f473fdb74ab8c"
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
