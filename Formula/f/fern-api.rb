class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.78.3.tgz"
  sha256 "cb4393bef5b0b9f70dd3bf35ab2c1dd60115b3eac715f93fc7a9d7b2a9f3a438"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ea05e822f9f0047532e718f3616f66bf587ef7989a745e1a5723fc3f440e5cf"
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
