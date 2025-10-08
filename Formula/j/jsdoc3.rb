class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-4.0.5.tgz"
  sha256 "a590c432d7a190fea72445db6b3e2f8d1f457832caa88e617dbb24984141f971"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "940d76a15d22ce61510764ebe2464657586e7e7be3a1602f0e6cf372df6a43d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~JS
      /**
       * Represents a formula.
       * @constructor
       * @param {string} name - the name of the formula.
       * @param {string} version - the version of the formula.
       **/
      function Formula(name, version) {}
    JS

    system bin/"jsdoc", "--verbose", "test.js"
  end
end
