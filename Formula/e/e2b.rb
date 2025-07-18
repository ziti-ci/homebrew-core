class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.7.0.tgz"
  sha256 "a3cdd213662dd3d507295c91826d331ac331c09e47b07cc8c17c887c3df71473"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "479b44ec151080c5d62f659b9576d00057098aeba18f5b2be455cb1ece0796fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "479b44ec151080c5d62f659b9576d00057098aeba18f5b2be455cb1ece0796fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "479b44ec151080c5d62f659b9576d00057098aeba18f5b2be455cb1ece0796fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9f7e7a64d91251a4e17339ee9a05f5255d24ba005d6b281d0365466cbc9e3d2"
    sha256 cellar: :any_skip_relocation, ventura:       "b9f7e7a64d91251a4e17339ee9a05f5255d24ba005d6b281d0365466cbc9e3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "479b44ec151080c5d62f659b9576d00057098aeba18f5b2be455cb1ece0796fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
