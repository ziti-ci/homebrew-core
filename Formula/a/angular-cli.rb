class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.6.tgz"
  sha256 "e06d1dd8a1f15edc69aa6309a6d65176600c2efb8b1d49588bafc0db1e70a5a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a33507cb934accaecc764cea9c4feda6419714e5aeea94315326c70f424714c"
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
