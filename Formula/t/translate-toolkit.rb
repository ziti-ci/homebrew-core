class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b0/62/567d25ae4fbd65db92428f78c414e34ad3d50b79af98b7944a774eeae0d0/translate_toolkit-3.16.0.tar.gz"
  sha256 "25873a142a5c98f7a114fc725e7c50e7f63df38ebc11db21437c527cf724880a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcc0b71aab87f1180335ec6e5964c4564159591587d95412b1d1af8669e904b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed0b7934ace4ed2218ba874336f33be7376e5160b06c3bd1e20df91e5b1a839"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19566e41f35b3efb72e620d59c81143a8d28381d03757ba8be8c9ce33655ea46"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b300bff317cb08f00dbf2d97d4e8436ecf2fa02da24b1a47ac0063d3b1889f5"
    sha256 cellar: :any_skip_relocation, ventura:       "8b09eb530d5a2fc1dcc18fb5f1f1057f19ff1b3694c185cfa4da0e197d4c9931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad53becdfce5fc01fd56af409ebf2152f16e065e43cd5d4e34ede6f367e3a118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf478255187403fb8a28044a7f8292c874253a7e1e3987637303943a898f8b0b"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
