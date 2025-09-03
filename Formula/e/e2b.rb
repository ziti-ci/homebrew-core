class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.0.3.tgz"
  sha256 "f484e184ff883de49d140556d65388b5f40bc4c2c728d59b79c4d6435c559f9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d847fd8b4edff30c2844b1248a7672462b07c73a89627a29dd1e72446400b38b"
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
