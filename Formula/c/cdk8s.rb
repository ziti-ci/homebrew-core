class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.27.tgz"
  sha256 "1b96fa6e50b6f5899c65524979333081cf9baa051310747176a6444b5ae842bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e8c851745d3d43e5ad4ab8c8cbe68fe0a28cf0939f60689c0283f04de465f26"
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
