class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/c0/73/8735d3464a0bf5cc074772514205e741dfa8d3f1f5fd765a3686ce7c8caa/Nuitka-2.7.13.tar.gz"
  sha256 "941c6ee2321fea1d297b29669228939200640110be2a8b0bdedfcf6c3bc816b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965958e7f4c54eb2958578aa167b3ad3fcb609836df3be8ab8664ce5a4ec3fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626ec20b7b5ed570db288cf912c32e85044c7367caf5b356ba9341be1a24cc5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b0fbeb3dd462c4e89b233349b76a820cd94f3db667cc57a06e4bd177a65534f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7188b05b2e1d02ea28b99c4943e6ed4ed2dd4e0ed8afafa384d086517c627325"
    sha256 cellar: :any_skip_relocation, ventura:       "eb48e45ba8e69e290316d2b5b329d09e127c979e387632b1728912bb7597ee22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0504a69c8bb7ac43172c4cc6de29bd59d06eb5181010e54d52672dced6c68254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9f041353a398a6115ae14d066db5f31bf2f326d1dad72a4fff06c72f1281e1"
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
    url "https://files.pythonhosted.org/packages/09/1b/c20b2ef1d987627765dcd5bf1dadb8ef6564f00a87972635099bb76b7a05/zstandard-0.24.0.tar.gz"
    sha256 "fe3198b81c00032326342d973e526803f183f97aa9e9a98e3f897ebafe21178f"
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
