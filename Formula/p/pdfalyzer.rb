class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/90/64/56ed42cadeee98717889cd6e8901a9c3d41d57a5ce5fcad7e17dc55d708f/pdfalyzer-1.16.9.tar.gz"
  sha256 "1df7f208b16d53aa8eb938546ff78fcc3d561f555e9efe59733a4ec07c59eb40"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bfca5f39e0290151395be5248498c4e90b98e5953d3abcee509eafb739c6cd2"
    sha256 cellar: :any,                 arm64_sonoma:  "78a66a0020255256d33a7598e3e76e6ee346a928d5be7f1564908e42d6478fd0"
    sha256 cellar: :any,                 arm64_ventura: "78525bbaed8d0b82a5e92dff94f32ac28bbc59622c5ba3693309f5b9b923935f"
    sha256 cellar: :any,                 sonoma:        "2ff2e4b78d0468497c1bdeb15890c5c65b42d5af54e880492fa617c9d4cffb24"
    sha256 cellar: :any,                 ventura:       "157e79e118cb9d4d4c9a207a2ac5b5dbae2b8cbbbef20799f2a4e841cde1ce64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a00ff132e64c7be14e44b66a479ce0732481fd89c42828f83a7c756c783b99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2217a872cc68cc94d50444dd8522a7b8e4b2c5039237c7ccfc876b7f5caeb4a"
  end

  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/89/3a/584b97a228950ed85aec97c811c68473d9b8d149e6a8c155668287cf1a28/pypdf-5.9.0.tar.gz"
    sha256 "30f67a614d558e495e1fbb157ba58c1de91ffc1718f5e0dfeb82a029233890a1"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f5/d7/d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1/python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-argparse-plus" do
    url "https://files.pythonhosted.org/packages/9b/34/75eaf9752783aa93498d46ccbc7046e25cc1d44e5f6c43d829d90b9dcd02/rich_argparse_plus-0.3.1.4.tar.gz"
    sha256 "aab9e49b4ba98ff501705678330eda8e9bc07d933edc5cac5f38671ee53f9998"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  resource "yaralyzer" do
    url "https://files.pythonhosted.org/packages/02/55/68038f1de2ca69f04d820768cf26f6aa8a19f116c280751417f02d8b78a6/yaralyzer-1.0.5.tar.gz"
    sha256 "46b9c7e7e5414645eb89463bbb15a28332cc6bc8b5ab6a403a4a19f7168690c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfalyze --version")

    resource "homebrew-test-pdf" do
      url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
    end

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}/pdfalyze dummy.pdf")
    assert_match "'/Producer': 'OpenOffice.org 2.1'", output
  end
end
