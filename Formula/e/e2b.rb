class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.2.7.tgz"
  sha256 "523e1cefd853f29e141a55ea012aeface2cbbecd544a0fdc2cc03cc91a418e7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d610916b5255a5640e314283f38008910ff20767cffbc7947717832169cb7ef3"
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
