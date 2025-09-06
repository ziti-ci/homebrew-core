class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.13.3.tgz"
  sha256 "e60d004b91c2201ea9976810e787e0017bf6160355079b5a87addaea26b0dbb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd09514469632bba3979f957f8c8befaf3e97e8f8410b2650370bdd887966e72"
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
