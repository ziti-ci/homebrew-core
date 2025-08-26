class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.6.tgz"
  sha256 "aa5ad80a73b51bd3aa414e6b033228506f0a7b6878ac8e2f1b7acb5f21b05ca7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7078fb6f48610473035261083bd853f7cd7cdd1014d6f73221c710e6b1719d4b"
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
