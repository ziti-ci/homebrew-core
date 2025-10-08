class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.48.tgz"
  sha256 "c3c4902584b4a6ff134f4cbb014963aff5334b95fda8f77c89abd786066778fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ac116764da46fc8c6f4bc8b95ca9dfe6f83d6e52699e6f831669dd0af76e3e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
