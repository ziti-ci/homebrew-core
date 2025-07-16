class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.1.tgz"
  sha256 "c7b1745622442eca05df4201d5407e12e696ac6b3f2496d2f1ea7a49fe61578e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8988a3fc7545d1837011473058a2a059ecd1811b3c9cd8dc7b55e9d2c6f717d7"
    sha256 cellar: :any_skip_relocation, ventura:       "8988a3fc7545d1837011473058a2a059ecd1811b3c9cd8dc7b55e9d2c6f717d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
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
