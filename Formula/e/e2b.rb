class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.0.2.tgz"
  sha256 "6fe718461642579d8ff65d17324a1ddd444868588834f42820ea1be7843b7d58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31d16be552ba0032f9e780abc143e86e1d18cd64030de286b3974ff9322006c9"
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
