class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/e5/87/36bae02fb19e98cdfa5778faf14f90acff396b9b17586355fbefbe971631/Nuitka-2.7.16.tar.gz"
  sha256 "768909faf365b21ae4777727fc4ae88efc29239c664bd177061fc907e263e0fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a74cb8e127839acdad3211bd1cecf4c2e122e46441c5c8536e1a0cca5672a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4569e10bf571c9cc4c0364d29b3d4e4fcdf193ab7d82a5e4a5649b53749bdfe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60cd7e39fbcf8504f8be4134969b36e5c02b78a326df2a490098e0011db9329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55eff93a7a9eb385341432c06567731606a2753ef4e6bd7ca7d53f722ae95a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "4efcbe16c0dde9784585545c3310df3127db4f65a969e6e80a056d60437f797f"
    sha256 cellar: :any_skip_relocation, ventura:       "6f9fce8b792ec1758e4c21d4017f148680c06e4ba7ab21644d8989b2fd36fb6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7dc252e98451a5a20b358de35e9f0a591074cd96d33bf645dd51e0161412407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863d93ab4574dbce8fde9707fd220338f25bdcdeb30f3e99447fc93d6b4fc38d"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
