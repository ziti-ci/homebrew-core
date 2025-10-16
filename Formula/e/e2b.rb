class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.3.0.tgz"
  sha256 "f875763c0086d9f04857ed348a7c2f9747ca932800be5dfca6b6b2ec418b8888"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02fa2e055dd756d41ac8b1a45d68606779c3b4117fba2f6fd4c34a1a5633201f"
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
