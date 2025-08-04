class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.1.2.tgz"
  sha256 "8d0338aa42b789ac78e710618898223bae6c0f266e683a844e999f6515d57d2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd5ea36353e3b2eb835e7a5ae4f1f07986aa88c35d71f0e48352cde53784f6a2"
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
