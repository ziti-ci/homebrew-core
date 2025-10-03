class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.43.tgz"
  sha256 "57f96e3cf3ec030107a096e19d84ee45d19d920819be824b0455af93ce71538c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b437f530a7eaf40b44ddd30ed063e8373b13c6e466a48c0241e269bca393661"
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
