class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.50.1.tgz"
  sha256 "913170194506de61e78e39ce57d12c66dcbca7585a89c0b0e0d2fd87c3981fef"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e82b0647c7b65cf3ee01804c115820f08de753325ed26bdab2c56339f97185d"
    sha256 cellar: :any,                 arm64_sonoma:  "8e82b0647c7b65cf3ee01804c115820f08de753325ed26bdab2c56339f97185d"
    sha256 cellar: :any,                 arm64_ventura: "8e82b0647c7b65cf3ee01804c115820f08de753325ed26bdab2c56339f97185d"
    sha256 cellar: :any,                 sonoma:        "63af20261b836d17ddb7528956d546734d8782e46e3de67102ba201564f8041f"
    sha256 cellar: :any,                 ventura:       "63af20261b836d17ddb7528956d546734d8782e46e3de67102ba201564f8041f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "478b1e0fdd91436096fadaba5709f3fdb37b7bf016cf02baa78d4eebbadec6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "115e04d54db0df0b9a5db98fae852facea7b8e19d6e7e3ebbeb2630aa98f78d9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
