class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.48.tgz"
  sha256 "c3c4902584b4a6ff134f4cbb014963aff5334b95fda8f77c89abd786066778fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c86850412d13662e99697d92fbf41e2d56017a35c59d5e3bd8237677e9a66ede"
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
