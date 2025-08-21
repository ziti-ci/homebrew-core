class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.47.1.tgz"
  sha256 "3ec73c37161ee7185d10582dad6c84e3f2b2ab11299e876db39cbcac98b051a3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1caee9bc8bda5770b5c7e7a812e9a4c727d491fba29a9bef25a3402856a90277"
    sha256 cellar: :any,                 arm64_sonoma:  "1caee9bc8bda5770b5c7e7a812e9a4c727d491fba29a9bef25a3402856a90277"
    sha256 cellar: :any,                 arm64_ventura: "1caee9bc8bda5770b5c7e7a812e9a4c727d491fba29a9bef25a3402856a90277"
    sha256 cellar: :any,                 sonoma:        "1040393fae21c55ddde0fa2f911dbc9302373d492ac8adec86443a2c64510120"
    sha256 cellar: :any,                 ventura:       "1040393fae21c55ddde0fa2f911dbc9302373d492ac8adec86443a2c64510120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "782cc821cd46b7553fee8ed64b14330c0e70436da82f138829fba9f7f9e92dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6994d47c4596f44889f95af90c9b8bbcb6a70001d763f13688da96d2bcca16"
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
