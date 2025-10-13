class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.51.tgz"
  sha256 "330281d93e940c47d76479c9fef3aef62bb33dffe3c0d8fb164643ec05c3240b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "606fbb2072c415339d54e165f0aa7f93168b8c47247d27954f794288718247af"
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
