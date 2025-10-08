class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.22.0.tgz"
  sha256 "cbb2af14437d177ba7ae9c244afc3f996408ae740bbdf4362943e9f7040c4c56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3598a4a89870956b5d23c85e9e33f2a51656a44c3a2756144cdc1de69263190d"
    sha256 cellar: :any,                 arm64_sequoia: "e1e6785c42a217475923d4e74d980507c8ede0d015cb4615367d928e08839730"
    sha256 cellar: :any,                 arm64_sonoma:  "e1e6785c42a217475923d4e74d980507c8ede0d015cb4615367d928e08839730"
    sha256 cellar: :any,                 sonoma:        "1e7de91fbd2eed6f6c69283f15e8bd8bc68a74d5b0a4833218945b6026511621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0866e14ecb7522c6df09c3e607d8716329180d1a09eacf6c2327efbf982432a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e87cc4365cfbbc280c4b87105f3f7e8bdb2f5d8bc359cab9a40fe730ee8680"
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
