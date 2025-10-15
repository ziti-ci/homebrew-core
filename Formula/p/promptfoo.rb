class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.16.tgz"
  sha256 "a15eaf3580ab0b941f78a4ebb57b434c39e0c4f9081af4732b9c1b541ce2f1ef"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e237591795d86dde4ce699ee3887e8baf7218b6d96989a24ad7ebf67197fd958"
    sha256 cellar: :any,                 arm64_sequoia: "970e8f52ec5b707a2adc21f55ea792decd4859ec6bbbc75344b1223576fa2243"
    sha256 cellar: :any,                 arm64_sonoma:  "d7cbfd4db999e7fd61ffade22b887ac2e644fd1d4f1479f156188c5c14e9873e"
    sha256 cellar: :any,                 sonoma:        "6e5ce0c0bd8160dbe03e022b7a1b1850479f717c95091e18685520e642742405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b749d3aca3ea10d5ad87b7df77dc562804a4903e97f5bd2b91bbd18ab383651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8699f0eeb1e0ac65991cac7dca513c16f01235d570a54a8c3fddf2479e9d3bd8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
