class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.75.2.tgz"
  sha256 "ce50af5660a262a014f071f1e3f0b556b1c68049330c111c9587c2414513f1d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5359e0aff01db3680661d3811fd6f95eae7546b8bc8bf9d9e70b6b7d5324514c"
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
