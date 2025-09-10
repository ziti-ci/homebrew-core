class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.0.tgz"
  sha256 "e906acfb0abaaa2f029bc0ac06ff3fcb59af0412c160c8cb67a4ab3faa17bec4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c8ac1e12333970207e14f2c813118805c862e364112360b2c2dc29d2f581d87"
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
