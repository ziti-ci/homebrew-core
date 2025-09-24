class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.3.tgz"
  sha256 "4f8a16b49c12703f9e0cab16c96d67d13cb10e3dd0cd850e4f515f1d2fa3ca9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c8754b69826130b5b82d34b2fd1eb8b89dbc930dcab4ea4c0403babc03d25cb"
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
