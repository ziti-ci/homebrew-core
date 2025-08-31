class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.11.tgz"
  sha256 "7a37a4fe2dc96d1e20528256f3d4c49acd94ba8455fef4868ebc40b7bf156e61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5eb4ab52b09a1cf5f41ceaa97bb72922b0130d19c2391ee8c5fb0788853ea0bf"
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
