class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/lucc/khard"
  url "https://files.pythonhosted.org/packages/2a/b3/492568d98d71f034d069138848764d23ddbc393e78f8a4381405157d5917/khard-0.20.0.tar.gz"
  sha256 "178f32ccf01c050b5cd9e736282583de9a6445fd98e00388df792207629bbdd0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "233a43b1af5d9cc99fb317e10ec0a1508276a1a64b81771d0035036298e9dd03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce93fc04d30ced8a224d1c44597a1446b5b65dab074dd3e19518775b437bbd89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8903230895d066074b7aee41a8e6de501184860cbf86ce5b1cc42acf9aedb40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d1e6b128ae04cf10d69d04a618f818d70486f5b4857e32eec69a920089596c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36da5861c3c4ef0f52dad66018508ddc509aa5ddb6072584f7b014fb7e7017a"
    sha256 cellar: :any_skip_relocation, ventura:       "2c5f36e56f7daac1e7e058d1279abe04a365bb049d19a9636a65d9c1ce5560ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c2da438d73230e52fb4e34e9ea6863edb218472054c93abe8ee58a382143d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378bca01eb81424251db35f4068ac17162141a9b23031d5762399dc1bc242506"
  end

  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/d0/8a/15c34b3d27c43fc81a467d0f66577afc5542326804c42f30557e31c3259e/vobject-0.9.9.tar.gz"
    sha256 "ac44e5d7e2079d84c1d52c50a615b9bec4b1ba958608c4c7fe40cbf33247b38e"
  end

  def install
    venv = virtualenv_install_with_resources without: "vobject"

    # Workaround broken dynamic version: https://github.com/py-vobject/vobject/issues/121
    # Upstream has unreleased fix by migrating to pyproject.toml
    # https://github.com/py-vobject/vobject/commit/6d907ee2c986b065794c3a50afdfb5f5677830f1
    resource("vobject").stage do |r|
      inreplace "setup.cfg", "attr: vobject.VERSION", r.version.to_s
      venv.pip_install Pathname.pwd
    end

    (etc/"khard").install "doc/source/examples/khard.conf.example"
    zsh_completion.install "misc/zsh/_khard"
    pkgshare.install (buildpath/"misc").children - [buildpath/"misc/zsh"]
  end

  test do
    (testpath/".config/khard/khard.conf").write <<~EOS
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match "Address book: default", shell_output("#{bin}/khard list user")
  end
end
