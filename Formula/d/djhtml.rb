class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/da/ad/5f36310d4306480af03a4fab7d06c2bdf94a9c35c9e2b6a1d98f2ac0036e/djhtml-3.0.9.tar.gz"
  sha256 "b21d7e6836b5aa8fb415233eb853ad14fdc26694f19ed17158ba71c97fa23f39"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30c255ebe8bca9d8a0251eb1e4eab05d094bb499104dcc5736a899481ff24826"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~HTML
      <html>
      <p>Hello, World!</p>
      </html>
    HTML

    expected_output = <<~HTML
      <html>
        <p>Hello, World!</p>
      </html>
    HTML

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end
