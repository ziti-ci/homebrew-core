class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.13.0.tgz"
  sha256 "2d751c81732b806974bcc0bdfdb3ded3e27732c71d3bf997ad510fb7366ca2d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1d65ecf810fbb836791a1680b6595054e46a38efad0bbcb8a0c9f17a793eb40"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run")
    assert_match "Packages with issues found", output
  end
end
