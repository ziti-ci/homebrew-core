class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/ba/dd/cc02bf66f342a4673867fdf6c1f9fce90ec1e91e651b21bc4af4890101da/bpython-0.25.tar.gz"
  sha256 "c246fc909ef6dcc26e9d8cb4615b0e6b1613f3543d12269b19ffd0782166c65b"
  license "MIT"
  revision 2
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "013b3275daac82275b2952151a574d1348e69141e1e3a284d5e8fd24db4bc882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a263d6c3e63b737e4e17b9fba497945b4eed2047c5ffadf482b808ae0c8a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86e7cb8e6e2e13d577a8c8c0af563c9f79e781e2c8e8fdae94623e7621a0f016"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "277fa9d83d7e25a4e647bdb8717ecb9dd3eded78238b1b7173c0a39e005ea23d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebd93b18c437c5ab683ec330e2ef1bfe8c5798e02d6176bbb1aab560d301b9b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f6db96e943d8a5a628d27f474560757a55f90561f8030357f486be5ea84d3330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93149a4f504fcb58489abc06b761ae8f2cc545928a582dfe99499b5950e33357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abbc3793c91f16115bbd341ab8dbc655d14669ffc4ceb9a80e04a24d6173df05"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/7c/51/a72df7730aa34a94bc43cebecb7b63ffa42f019868637dbeb45e0620d26e/blessed-1.22.0.tar.gz"
    sha256 "1818efb7c10015478286f21a412fcdd31a3d8b94a18f6d926e733827da7a844b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/d1/18/5741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91/curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  # Fix to build with Python 3.14, remove in next release
  # Issue ref: https://github.com/bpython/bpython/issues/1035
  patch do
    url "https://github.com/bpython/bpython/commit/064ae933ee909e87c3b698a5fdf5c3062c5a318b.patch?full_index=1"
    sha256 "591cee829b44aa00967bb53cfdc9d21b96b5439d2b0b6a3b9bc9f12d242bc3c3"
  end

  def python3
    which("python3.14")
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
