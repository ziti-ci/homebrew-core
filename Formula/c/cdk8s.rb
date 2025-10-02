class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.42.tgz"
  sha256 "f12f972b53145721004f0d29034c2732e8810201aeb0d1ff6efa2fca066d88da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f203fd34d99684fc92c22cc2a92a715b3a32f81e44fa534a57cc26bc04f117f7"
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
