class Easyeda2kicad < Formula
  include Language::Python::Virtualenv

  desc "Converts electronic components from EasyEDA or LCSC to a KiCad library"
  homepage "https://github.com/uPesy/easyeda2kicad.py"
  url "https://files.pythonhosted.org/packages/f1/78/fde265892294c733590a9089f37cc8ea1478b9c632d76c0a11b8f20fe6f3/easyeda2kicad-0.8.0.tar.gz"
  sha256 "a781be6d1076f6e06886a4292373eb930c9921de4c709d6dd91bb6ea104f4a4b"
  license "AGPL-3.0-or-later"
  revision 2
  head "https://github.com/uPesy/easyeda2kicad.py.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b99e1fab064fc0d855bfc64c8bc84473f5807a0a8b616f14e0a3c71bba875e1"
    sha256 cellar: :any,                 arm64_sequoia: "ca4a1da140fed0775fce219fdc949815dbc2f40caeb84265e2a68b630ad79a9c"
    sha256 cellar: :any,                 arm64_sonoma:  "0e4978fcf4183050761e4b428e20c5458aaa9f1985a75fa8705b30691e62c18f"
    sha256 cellar: :any,                 arm64_ventura: "77002318fed574154a9d70f276b74ed051c394b6f10b534ec7229ebec4136a40"
    sha256 cellar: :any,                 sonoma:        "eba8a9cac3e6abf87eca3821848aebff82f63f189689fdc4f38c5a167b241fc8"
    sha256 cellar: :any,                 ventura:       "097bbdd985c8b6c1a6f6f40b060b45edf4d92b2551b7acb4dd815559d2e15e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c1e471d05a94eb20b07b1ed2c49689f07c48fd48642652f7c2a8b78d96724a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a821a9287213946bbe364302f95659ab250a1aea2a69a1a661d9398d0efd9e40"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4c/5b/b6ce21586237c77ce67d01dc5507039d444b630dd76611bbca2d8e5dcd91/certifi-2025.10.5.tar.gz"
    sha256 "47c09d31ccf2acf0be3f701ea53595ee7e0b8fa08801c6624be771df09ae7b43"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/3c/a7/d0d7b3c128948ece6676a6a21b9036e3ca53765d35052dbcc8c303886a44/pydantic-2.12.1.tar.gz"
    sha256 "0af849d00e1879199babd468ec9db13b956f6608e9250500c1a9d69b6a62824e"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/00/e9/3916abb671bffb00845408c604ff03480dc8dc273310d8268547a37be0fb/pydantic_core-2.41.3.tar.gz"
    sha256 "cdebb34b36ad05e8d77b4e797ad38a2a775c2a07a8fa386d4f6943b7778dcd39"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"easyeda2kicad", "--full", "--lcsc_id=C2040", "--output", testpath/"lib"
    assert_path_exists testpath/"lib.3dshapes"
    assert_path_exists testpath/"lib.kicad_sym"
    assert_path_exists testpath/"lib.pretty"
  end
end
