class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.12.1.tgz"
  sha256 "5a47cc071de4da4d386332febb16f245b76eab6c7a3999b361c1641221d5c343"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83aa6cf7b578bda46e289a400365eb832bb3805add285c78eb914a4d6188adf2"
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
