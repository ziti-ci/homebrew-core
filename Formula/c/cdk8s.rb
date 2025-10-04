class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.44.tgz"
  sha256 "bb0ac87ce004267ace4419eb6be2f1c759b1e776db4ea19a5590e627eb6bcddc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c8895c2033088de73fe0f80acbffc30c9509b575654fcde072aa279d0114bc3"
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
