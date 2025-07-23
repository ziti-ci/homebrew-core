class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.139.tgz"
  sha256 "b88da9358e5c760d295c6b98213c034f76fa03ca79167d0018d062b2751b7e6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ed4a99eeeec4fe3a5192314d62426c5834edb4328a9021ebe6ddfc9610f8c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ed4a99eeeec4fe3a5192314d62426c5834edb4328a9021ebe6ddfc9610f8c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77ed4a99eeeec4fe3a5192314d62426c5834edb4328a9021ebe6ddfc9610f8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0a688a620138deb7bd05d8bf0eee46659dcde7b7227537f82bae678008711bb"
    sha256 cellar: :any_skip_relocation, ventura:       "e0a688a620138deb7bd05d8bf0eee46659dcde7b7227537f82bae678008711bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ed4a99eeeec4fe3a5192314d62426c5834edb4328a9021ebe6ddfc9610f8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ed4a99eeeec4fe3a5192314d62426c5834edb4328a9021ebe6ddfc9610f8c2"
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
