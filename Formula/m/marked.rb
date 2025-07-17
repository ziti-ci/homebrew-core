class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.1.0.tgz"
  sha256 "15def28737707f9ec227a79734e901631b5b3099c4950db234ae1a9ceef0257f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f9eb67cdebc7d9ebdcaaed516a022063d64fc652ccceaad1564fd722fa2ebab"
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
