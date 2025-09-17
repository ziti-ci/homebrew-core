class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.2.tgz"
  sha256 "c370be26a7d654dcfea0bb389066a2dbaaf26b10680424aa0a4ad91dadeda3e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cea19ac0583a725e19f21ae41156720affd0d85e36bc551639214f195b2a20af"
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
