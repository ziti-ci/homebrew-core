class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.1.1.tgz"
  sha256 "ea440289ca9d7dd6e2505bf95dd02be6fb56ab618f63e1db6a452a6b1c55224b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68fc16328c5514bfd180ccd8e8b1a4b8f0d1ecde1e6881eae803d6f41f1d8311"
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
