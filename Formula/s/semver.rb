class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://github.com/npm/node-semver"
  url "https://github.com/npm/node-semver/archive/refs/tags/v7.7.3.tar.gz"
  sha256 "227a8c2bfeb87a3e51db6ee7efffb12915ed4318c25d215edebdc23863482a21"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f31f20e5ff4a1429f55c12c0faa8b1a3fb0b9f9ad9d7d6d73f023d8bd8868af3"
  end
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semver --help")
    assert_match "1.2.3", shell_output("#{bin}/semver 1.2.3-beta.1 -i release")
  end
end
