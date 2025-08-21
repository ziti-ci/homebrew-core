class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "007ce884bf1ba757929d119f792b3b414b4ce3d46b842c43e270941cf1fb7b3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "007ce884bf1ba757929d119f792b3b414b4ce3d46b842c43e270941cf1fb7b3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "007ce884bf1ba757929d119f792b3b414b4ce3d46b842c43e270941cf1fb7b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1903d84db5712fa94b88bd6adafe8efd3686665cb0dc17db3d5ed63a41bdd0f6"
    sha256 cellar: :any_skip_relocation, ventura:       "1903d84db5712fa94b88bd6adafe8efd3686665cb0dc17db3d5ed63a41bdd0f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa99b757bdae56d1db08f94e6b9fe4056dda2d9800aa0354191bb1edfd79c58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007ce884bf1ba757929d119f792b3b414b4ce3d46b842c43e270941cf1fb7b3c"
  end

  depends_on "python@3.13"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/ad/8d/23253ab92d4731eb34383a69b39568ca63a1685bec1e9946e91a32fc87ad/pbr-7.0.1.tar.gz"
    sha256 "3ecbcb11d2b8551588ec816b3756b1eb4394186c3b689b17e04850dfc20f7e57"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bashate --version")

    (testpath/"test.sh").write <<~SHELL
      #!/bin/bash
        echo "Testing Bashate"
    SHELL
    assert_match "E003 Indent not multiple of 4", shell_output("#{bin}/bashate #{testpath}/test.sh", 1)
    assert_empty shell_output("#{bin}/bashate -i E003 #{testpath}/test.sh")
  end
end
