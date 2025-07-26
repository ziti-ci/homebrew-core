class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.142.tgz"
  sha256 "b162df9455b0c00d8b34eab4db75c03b2a9ae4660859d0ce9d9afdb17b76e07f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a42d228df9bb54e1d2f4f5110c07c36d0f5866b5958c74a67b326fe4275c6cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a42d228df9bb54e1d2f4f5110c07c36d0f5866b5958c74a67b326fe4275c6cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a42d228df9bb54e1d2f4f5110c07c36d0f5866b5958c74a67b326fe4275c6cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ec3dcff35f3f25e45289e5239bd0753d162092d95ea971eee1874fb31ea3b3"
    sha256 cellar: :any_skip_relocation, ventura:       "f4ec3dcff35f3f25e45289e5239bd0753d162092d95ea971eee1874fb31ea3b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a42d228df9bb54e1d2f4f5110c07c36d0f5866b5958c74a67b326fe4275c6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a42d228df9bb54e1d2f4f5110c07c36d0f5866b5958c74a67b326fe4275c6cb"
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
