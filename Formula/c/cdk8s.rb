class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.5.tgz"
  sha256 "171f6bae5be458eb54fbda1bb2e14b6f8f1c07209432fbe0b483bc6188a49d01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "175e0651f7703a381391339ac7d8c134345439b57e4969cc2c76ad47d9106796"
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
