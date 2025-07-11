class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.127.tgz"
  sha256 "09a1b826f9e3d2e639eca16230e90aa8770d582b17059377fff5f688b123f100"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6183d265d4f52e95d16523cc2820ac8b92c1dc3e81c980a9ce8e375c72dd74d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6183d265d4f52e95d16523cc2820ac8b92c1dc3e81c980a9ce8e375c72dd74d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6183d265d4f52e95d16523cc2820ac8b92c1dc3e81c980a9ce8e375c72dd74d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd4790ea5cab6a42a0eaef6564a986f4950272de2bd45f28c2e4311bdc22691a"
    sha256 cellar: :any_skip_relocation, ventura:       "bd4790ea5cab6a42a0eaef6564a986f4950272de2bd45f28c2e4311bdc22691a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6183d265d4f52e95d16523cc2820ac8b92c1dc3e81c980a9ce8e375c72dd74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6183d265d4f52e95d16523cc2820ac8b92c1dc3e81c980a9ce8e375c72dd74d"
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
