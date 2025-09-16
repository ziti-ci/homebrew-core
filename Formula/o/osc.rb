class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/a8/54/f8f8fe028883d7ebe78912d001ca23147199ad116d078e4872d914fd98a2/osc-1.20.0.tar.gz"
  sha256 "c35375e3ceb382dd771c286f20ccbbde0d94454c0a8c04985bfb27832a9a1cc7"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbe3f738a1dd7d91b6edf445e9e0dee654256905c9fd35bb3b0df7b738a0792c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57387af026a72b95694381b3b019d130c989fda1d4502626e8da4a8343b378f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758f75779b3723115c16e5b62e97cf986a3d4cd2a510a5e7644f5b893079c8c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e60c47c61481723867a43258980257046c13bd74e6dc39406c96575674d85535"
    sha256 cellar: :any_skip_relocation, sonoma:        "84aed3b197a8623d34c3cca517140cfb50411364d60f19f4ba265ac99753a08e"
    sha256 cellar: :any_skip_relocation, ventura:       "f5304858b6b47375ae06e0b7e3df2bc2ac2600b3373531bba14c6a95ac102f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be32b1df3efbf5b739f4101816e2a8f950b2f49de3918c8b28b0004a512d8667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058e22b91034b003a709407b047a561c7c756f5dbba84c4ee28999860f7f42a8"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/bd/ce/8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265/rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
