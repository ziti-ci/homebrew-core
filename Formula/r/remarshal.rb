class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/remarshal-project/remarshal"
  url "https://files.pythonhosted.org/packages/cf/93/6272970b145b91afbd8bc4c2224e528b6f629003f4f44dccda7080ece440/remarshal-1.1.0.tar.gz"
  sha256 "6322b1eb87c1c7414d41f77b654215f6b036084ae8647ba6393b3e63c13e660c"
  license "MIT"
  head "https://github.com/remarshal-project/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc4b38443668813529bb77345a855e5b8410588ff3dcf0ce29d8c48129733a97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8566681a2e0b3a3d044c026a79bf80a4e96d37ffe3129a85d4518036bf27c94c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8faf07e809b78f2dfcbaa4d3f01b2984ecb67e2c6897ef0e4dc25fec1f17c3d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be81ab939a9100e4536f68aaae8643a9e1034858ab5c1dcb5f52579b4e6d4eff"
    sha256 cellar: :any_skip_relocation, ventura:       "6d1c622d9e463fc8b1da20741a1c644d072c9a58f273bbb8f877e338059ed73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e28572308fbd6c95787366f142635b70671ff5f51f6ef9cc3f34ce1be8a54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b900cb2e9271d6eedaca123d74373503f68b8cf2ce7ac894b5857fa6d3315664"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"
  conflicts_with "toml2json", because: "both install `toml2json` binaries"
  conflicts_with "yaml2json", because: "both install `yaml2json` binaries"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/3a/89/01df16cdc9c60c07956756c90fe92c684021003079e358a78e213bce45a2/cbor2-5.7.0.tar.gz"
    sha256 "3f6d843f4db4d0ec501c46453c22a4fbebb1abfb5b740e1bcab34c615cd7406b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/71/a6/34460d81e5534f6d2fc8e8d91ff99a5835fdca53578eac89e4f37b3a7c6d/rich_argparse-1.7.1.tar.gz"
    sha256 "d7a493cde94043e41ea68fb43a74405fa178de981bf7b800f7a3bd02ac5c27be"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {"foo.bar":"baz","qux":1}
    JSON
    yaml = <<~YAML
      foo.bar: baz
      qux: 1
    YAML
    toml = <<~TOML
      "foo.bar" = "baz"
      qux = 1
    TOML
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json, 0)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json, 0)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml, 0)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml, 0)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml, 0)
    assert_equal json, pipe_output("#{bin}/toml2json", toml, 0)
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml, 0),
                 pipe_output("#{bin}/remarshal -if=json -of=msgpack", json, 0)

    assert_match version.to_s, shell_output("#{bin}/remarshal --version")
  end
end
