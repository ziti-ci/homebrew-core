class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.0.tgz"
  sha256 "d966f1f9bb291a6b3476517e63aa7354641d5fcb3998d3c2d9325f4b008f2047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8918bdafde8435d4537c5be62ad2cd540bfc65dc33ec4078b0af5d01859a7bbe"
    sha256 cellar: :any_skip_relocation, ventura:       "8918bdafde8435d4537c5be62ad2cd540bfc65dc33ec4078b0af5d01859a7bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ea3de5c5784daedcf35a92f4641c661f3a683f9e8c40c0b32464952a7d88b9"
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
