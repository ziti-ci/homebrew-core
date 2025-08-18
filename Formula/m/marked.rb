class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.2.0.tgz"
  sha256 "688e39c361ef7d92f9c69b2aaedcdafa4038865f4efaee30f5831ad53dd7909e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a00e95b6f44bd612791e05d67be212304a10f425b69d94abcd82bcd242220ad9"
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
