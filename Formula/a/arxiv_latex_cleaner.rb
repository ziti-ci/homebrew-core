class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/7b/be/e0afb37ba09060368e3858c8248328faf187d814f9cb9da00e5611d150d0/arxiv_latex_cleaner-1.0.8.tar.gz"
  sha256 "e40215f486770a90aaec3d4d5c666a5695ce282b4bf57cdd39c2f4623866e3f4"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "48613dd88f7ef8944fc04fe18fadc3bfab600ed072542ebca75b922621ebbd9b"
    sha256 cellar: :any,                 arm64_sequoia: "997cbbeeb1ce449be8bba1670259cc32c7ecfc695f5ae180934a337e9b2838ad"
    sha256 cellar: :any,                 arm64_sonoma:  "78d0cd82ce9bd8cbea655d761488bd02c4a3104f8778ae41dc714d36b7dbf07e"
    sha256 cellar: :any,                 arm64_ventura: "48cbd0caca0dc51f270ba3a24c4b210af0b4f357f4c3e55a4d94d0cf1938ff1d"
    sha256 cellar: :any,                 sonoma:        "68c37e6f15ae97a4d6f6b73b0909f5125e8e9008ecf232b64ed361f3cecc57fd"
    sha256 cellar: :any,                 ventura:       "cf9077ef07516d834c831390842e96d99557782f2b325882ef49f47047588668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f637752ba528e9997985db1838ea731916f459f907ee6b55ca031dbde41a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4640b0c29323b9ae3aa92fc30eb65137ca20d51ccc578f51d51b1f52cf7da29"
  end

  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/10/2a/c93173ffa1b39c1d0395b7e842bbdc62e556ca9d8d3b5572926f3e4ca752/absl_py-2.3.1.tar.gz"
    sha256 "a97820526f7fbfd2ec1bce83f3f25e3a14840dac0d8e02a0b71cd75db3f77fc9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~TEX
      % remove
      keep
    TEX
    system bin/"arxiv_latex_cleaner", latexdir
    assert_path_exists testpath/"latex_arXiv"
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
