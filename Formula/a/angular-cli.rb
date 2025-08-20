class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.2.0.tgz"
  sha256 "f190fc138d68e5e795757d30ae62dc49b2d4d3292dcf5803c58bb3661d61fda2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "489c583038ad9f3dac1b1be6f9364dcf73c40a9a5b82849d74ad7aea62e9c3e3"
    sha256 cellar: :any_skip_relocation, ventura:       "489c583038ad9f3dac1b1be6f9364dcf73c40a9a5b82849d74ad7aea62e9c3e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
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
