class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
  sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "2ef15b6e42239659f61e4641455f8b62f95923d90050641c393f63b0ab0819d8"
    sha256 cellar: :any,                 arm64_sequoia: "4d1555e8e1817baca2b6923fdb04c78ad0e4e31c8a73335cbb25572c8d90ab5e"
    sha256 cellar: :any,                 arm64_sonoma:  "af5461c5eec7061d03b600d697c31c9819f0601bc2340636b852beb2b48e67c1"
    sha256 cellar: :any,                 arm64_ventura: "462f81ce1dad72d97411bc6dd9413b009dd661f9ea562a2f388343363f072ed8"
    sha256 cellar: :any,                 sonoma:        "887b91b1a6d0a1ab97b9a4d114575f9da05e0bc54568ce249f0b8f02d897f6b7"
    sha256 cellar: :any,                 ventura:       "421882203efbb325031a85f98942f5f0a46ac043595c855b77037e7a6fbcc4ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa678291a94d4bcaca4e18a4f0e0067dabc7a7fa64c1fc89ee37504ad7d55e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250317267233bf7f607ad268ddd2089c29f8722840ba8a3f37a1a33603f84911"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.14"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~PYTHON
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    PYTHON
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
