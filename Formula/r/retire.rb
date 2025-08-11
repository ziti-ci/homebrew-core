class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.3.0.tgz"
  sha256 "e7b322111bec8b80b45b94d3276f4fe2e5ec986b835ee9c46d05d2a2de06a9b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5fc2fde4f6e93781d99c947a355f9b75ce484b2eb5e735cd9e48669eb384bf2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
