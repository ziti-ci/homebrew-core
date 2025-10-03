class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.6.tgz"
  sha256 "72ba8095f4412a5089cc37a4e31dd7c0bf4a70c248f3bb6a5d2e3763a3e349ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa137499709d47e775c984e2a1ccdc45117ea6b94b0cb1fba26fdb3bc934379a"
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
