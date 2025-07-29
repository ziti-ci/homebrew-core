class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.144.tgz"
  sha256 "0fae99ed728a0346a717ab52203f735c8ebbeaf7e41c8f973c4620f5cf26288a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef310c690d3f6caa3a15b608f49fac326f12b3eb3ae35be59f44dc43c60b483d"
    sha256 cellar: :any_skip_relocation, ventura:       "ef310c690d3f6caa3a15b608f49fac326f12b3eb3ae35be59f44dc43c60b483d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
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
