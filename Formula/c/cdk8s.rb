class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.136.tgz"
  sha256 "cd6f65a810d556c47ae0218186cfe525dee7837454d9a68827e54c05b7cee553"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0044736b6048c37fc5ff97d5c611377b5d32b683d14fc34f711048f179199d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0044736b6048c37fc5ff97d5c611377b5d32b683d14fc34f711048f179199d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0044736b6048c37fc5ff97d5c611377b5d32b683d14fc34f711048f179199d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "65854ac5623b1d893f167908f54a199c12eac9607c597c461f9f04b6365abd8c"
    sha256 cellar: :any_skip_relocation, ventura:       "65854ac5623b1d893f167908f54a199c12eac9607c597c461f9f04b6365abd8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0044736b6048c37fc5ff97d5c611377b5d32b683d14fc34f711048f179199d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0044736b6048c37fc5ff97d5c611377b5d32b683d14fc34f711048f179199d3"
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
