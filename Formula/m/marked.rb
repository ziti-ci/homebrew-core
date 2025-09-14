class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.3.0.tgz"
  sha256 "c333c47cd3802a1d631dfdd8c6cfc411a88599a872c04ce8cd2291381a7767a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8447f86b22fb7ee28a60b08795213948b2eca1bdf582da7cfd32548e93b0922"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
