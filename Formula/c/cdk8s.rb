class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.2.tgz"
  sha256 "564bd3c50650e31253b5fc929175e9e2615744bc65ddffc504c57bbf95c48fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae36f8d0787835757aeb31acaf2480e63968b7a7593af8c77ff9137e5871045c"
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
