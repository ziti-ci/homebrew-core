class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.1.tgz"
  sha256 "d57de0b01db3167d4f34d203a96e33262194db1cea4243c2ea571db77cd3fd96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "639a8c943d032323a12482028c79a96b15071b4f52a766e90cfcbf4f07776a94"
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
