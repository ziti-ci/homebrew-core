class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.13.5.tgz"
  sha256 "9f139f4aa00c4cc896a39725411d23b146e4eaf327e05be7dde5a39e66a1070a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c55572ddab40d3449400239dd83b1d825752564cfbb5c14a3bb2a0f9e19188fb"
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
