class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.2.1.tgz"
  sha256 "73c2410362ab97a6fc0ea3864d63f789cdbe6b6fd1258bfd20a4af8c2a93e51d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60adc77d92560c2a20a41a5814bf7ce15cd567e97efdadf2627a53f47a251299"
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
