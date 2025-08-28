class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.8.tgz"
  sha256 "ac10ef1ff66547fa026f8e15ff5f11103c51b5b961a9d903546f4225c386d933"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37fa546ce9d25c42ae88cc62ab9cefad393b332c77882cb02ae744e58eeab9df"
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
