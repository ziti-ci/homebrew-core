class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.2.tgz"
  sha256 "b32dae800b887e1838ffeb42f1ec774eaa343361c1bea2944bd333dd58dc1bd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1526ab3d7a4ae329c4823c2bdac69695cf9a5e65ced8ab5a4206b685c43e095"
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
