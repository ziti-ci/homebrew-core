class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.116.6.tgz"
  sha256 "83c79ce6dbc3540cf74fb067627aec2a780e2d26f90c797dc84e06c7732ac8f5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "edf3468ece542a58b6c11a5cae1ec74200c193604d76f293d1ea4d90f4ddcf51"
    sha256 cellar: :any,                 arm64_sonoma:  "64516b96205b16951a673d3e34bd28e0c2df0dc5eef03387e7bcdcef7fb879da"
    sha256 cellar: :any,                 arm64_ventura: "1ba997e40e9fb146296d76489b13b32ef6471d639ce9a5db2d5f804f7b6752ac"
    sha256                               sonoma:        "98f51d4bba9e610e129e79c10837f0a173bb6f66eddd660224e8de096d47abf8"
    sha256                               ventura:       "7d5edb66f4f8428915d734f4593f97c1bc925e71afbff7500a675a7a549331fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9402d6407d4000c5bb1ba20a926d7fab659905ac3f68763489b9595174770378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7c3115b6b4f2d295464e192ce099f6297b9a46048b7c3e98fb6bfe50ee8851"
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
