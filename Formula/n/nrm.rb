class Nrm < Formula
  desc "NPM registry manager, fast switch between different registries"
  homepage "https://github.com/Pana/nrm"
  url "https://registry.npmjs.org/nrm/-/nrm-2.1.0.tgz"
  sha256 "cdad289ac8e72878ab72575ee61551b5d1cb6334097d6904f5ce30603ae5c74f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8ef94c49faddff846db68abb006e2c3973688b0f2b9aab235b933156dae66be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8ef94c49faddff846db68abb006e2c3973688b0f2b9aab235b933156dae66be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8ef94c49faddff846db68abb006e2c3973688b0f2b9aab235b933156dae66be"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cad57eed54947a284788f5ea7b977b8e3086c04707a384e689bb0e4f4925735"
    sha256 cellar: :any_skip_relocation, ventura:       "5cad57eed54947a284788f5ea7b977b8e3086c04707a384e689bb0e4f4925735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ce402b087b6886249926829cb3bfa7759b62b3f0bc4ac76cd680dcc78f86ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ef94c49faddff846db68abb006e2c3973688b0f2b9aab235b933156dae66be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "SUCCESS", shell_output("#{bin}/nrm add test http://localhost")
    assert_match "test --------- http://localhost/", shell_output("#{bin}/nrm ls")
    assert_match "SUCCESS", shell_output("#{bin}/nrm del test")
  end
end
