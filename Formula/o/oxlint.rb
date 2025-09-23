class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.17.0.tgz"
  sha256 "bf531ea49243f496c7d5499c224ad6ac5e24572ab8ee9f7e99a12d0b118fad06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d726454b63a287931adb025a9e208acc6f499375acd5b4e57d8bfdd58fac36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf1375d47c30355fb2a99e421975a9259e1da14308b5d1dcf8857797cd2111a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894059d25c8546e626ebd9ab0685ede0821e72e755802c8d0fa3a7dce2130585"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f87745df29614cf5a6be4b22710b58dec94497612b4d8154f6078115a7a123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c959606a94d2d0c8dc4bad42934c7cf476354de4d33478506ab2469de36f163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "897dec137037fef304cdc0ebc976dceb6e9a212128438103603857fb4d713a15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
