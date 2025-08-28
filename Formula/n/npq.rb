class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.12.0.tgz"
  sha256 "9bcaf8969d7bf68fffed053e07574c9614da9f5507ba1c170eac505e17c50106"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb5819ede2698b3ed33846ba0828e27675131da974a189ee80522576b7eb2f63"
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
