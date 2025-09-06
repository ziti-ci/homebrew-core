class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.17.tgz"
  sha256 "31c44ae07fcf44f1fdbc9ecedbd9cd96299226bc6ae58079fb23dd14fc80731b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69b80bc6e4473157ded42a38d6fe17270bf3f5fda5a4785718a204f0791073aa"
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
