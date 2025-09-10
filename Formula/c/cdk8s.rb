class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.21.tgz"
  sha256 "9b6080b99373fea3d67e02064315c6143d0326629b30a7f10d73549cf48666ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7279023110bd7a6a7b89ad20d48179a8c66a5a329173a2084a41d5b4b39af152"
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
