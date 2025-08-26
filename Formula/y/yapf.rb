class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/23/97/b6f296d1e9cc1ec25c7604178b48532fa5901f721bcf1b8d8148b13e5588/yapf-0.43.0.tar.gz"
  sha256 "00d3aa24bfedff9420b2e0d5d9f5ab6d9d4268e72afbf59bb3fa542781d5218e"
  license "Apache-2.0"
  head "https://github.com/google/yapf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf15857b390cc7e51ca27c742c839b71035382d701e298354fcf521318da61b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf15857b390cc7e51ca27c742c839b71035382d701e298354fcf521318da61b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf15857b390cc7e51ca27c742c839b71035382d701e298354fcf521318da61b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b02bec0b509d12c45e027c20377d2cc927156f932a156cb08e75cf3d0a16b0c"
    sha256 cellar: :any_skip_relocation, ventura:       "6b02bec0b509d12c45e027c20377d2cc927156f932a156cb08e75cf3d0a16b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a8928518e665fbbdc956986ec490c577990c536de1c0b233590557e0f0cb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4bdbca92626b2c3c57566193c8fd2f66ff8ecc670d8ee8e9e495be42f33cf37"
  end

  depends_on "python@3.13"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
