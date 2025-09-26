class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.9.tgz"
  sha256 "51f3ba0b1836d7bd57c49fa265c91c15aa9600bb193fed338b474d9e32346eb5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12b7549fed03bb17f69a7079b755d55c4b7818d055f3d0741e5d84b151cf0b96"
    sha256 cellar: :any,                 arm64_sequoia: "5af7503f09ca5d71b26b2e8a4cdf6083d56f69005a09ce939fb51b71928eafbd"
    sha256 cellar: :any,                 arm64_sonoma:  "7d84dae0a9cf644e5d4014866e75c78377266bf36c7990894e03a65347088a54"
    sha256 cellar: :any,                 sonoma:        "36b86ef27934631fb64ec1f67d3f71ebfce486b2ef13010e1f2c90f64beef6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5ef345759ad0130e0f5b43557418d07b8aee2c040aeffed044d707ec4841db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331c462281a3a24cc17e95f8e8b97d319215a56070dfeb9cca76d36a083e93bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
