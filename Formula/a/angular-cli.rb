class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.6.tgz"
  sha256 "60f5f3291ae123ee8d5a708f4289e7c3cdcf32882ecb8ef4188d6b29ca69018c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d9137deeab9ea3d182bea4fee16dda1661b112d7c78c188e401cff9bee60f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d9137deeab9ea3d182bea4fee16dda1661b112d7c78c188e401cff9bee60f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d9137deeab9ea3d182bea4fee16dda1661b112d7c78c188e401cff9bee60f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a28a1baec70765820fccc3b2b857a835f764935ed8515f6a56f42a9f06991694"
    sha256 cellar: :any_skip_relocation, ventura:       "a28a1baec70765820fccc3b2b857a835f764935ed8515f6a56f42a9f06991694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9137deeab9ea3d182bea4fee16dda1661b112d7c78c188e401cff9bee60f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9137deeab9ea3d182bea4fee16dda1661b112d7c78c188e401cff9bee60f7c"
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
