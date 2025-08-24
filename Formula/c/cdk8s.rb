class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.4.tgz"
  sha256 "7fb8814d0d4a52e3978c1e7037656d05f0ccc8bc021b94536facc31a21616262"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4db1bab005415e940846729c78194c7144b3d28139b57662d7f252fc70b544cc"
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
