class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.1.tgz"
  sha256 "f3db29b39754008a1b5da9d698c0b57c5418a863c78733dbe7002d8c95fbf26f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "644b60e492f6119ac99d273cb35cb3454acac40e4572e4df428b17f2d0069887"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
