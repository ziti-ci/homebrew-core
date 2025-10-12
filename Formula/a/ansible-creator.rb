class AnsibleCreator < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for scaffolding Ansible Content"
  homepage "https://ansible.readthedocs.io/projects/creator/"
  url "https://files.pythonhosted.org/packages/bb/a4/8f943e48e48cb3d953505313be4b4cc072e3c66ff3abcb2745ecf9a17676/ansible_creator-25.9.0.tar.gz"
  sha256 "f20e8ceb98606ddd0a60587118403f26916f2e53d01b6d42356e448c3e7fb76a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41da6114493aa4f38a0c6bc5b8dd886f84c39631a9ab9aa28e1375e51b6bd971"
    sha256 cellar: :any,                 arm64_sequoia: "c74e0611b7f4e8a72f29883c1468f581689ac5157bda3a35b271afad1f5f3960"
    sha256 cellar: :any,                 arm64_sonoma:  "ebc94cb5e66670ac2bdbb72131ef8264bdb077b12bf8daa5ed06eb1e8120271f"
    sha256 cellar: :any,                 sonoma:        "31abe616acc38569853957573320760519a4c1ccd14e98901c2890771911b4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3dcb41eff0196b2128194ee53264c0cd4077fc54a837dc76f8fe0c54486356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c338218da45832d995632efe951ec664d409a0689fbd046ea6a9d99fc4cead9a"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    system bin/"ansible-creator", "init", "examplenamespace.examplename",
      "--init-path", testpath/"example"
    assert_path_exists testpath/"example/galaxy.yml"

    assert_match version.to_s, shell_output("#{bin}/ansible-creator --version")
  end
end
