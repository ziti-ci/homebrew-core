class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.31.tgz"
  sha256 "b291932c020ea2c4202292e8958fe7298ca533aaaaa4f70a11f8cd5a5a83627d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96fab01a19424e1057fe9d3111488daefd08f8f0369530d2028d803ae4d86d56"
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
