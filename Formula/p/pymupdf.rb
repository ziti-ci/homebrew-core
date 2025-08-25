class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/90/35/031556dfc0d332d8e9ed9b61ca105138606d3f8971b9eb02e20118629334/pymupdf-1.26.4.tar.gz"
  sha256 "be13a066d42bfaed343a488168656637c4d9843ddc63b768dc827c9dfc6b9989"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b01ccd69f4bab2dd1c476bad9c5f33a735f2588f7ea0bcb911f731d34fdffe8b"
    sha256 cellar: :any,                 arm64_sonoma:  "cb317aec65bbbc103240ae0c9a097e84b42b66dd73e8119f7da89e2de639bfb9"
    sha256 cellar: :any,                 arm64_ventura: "51f2a12a73428b852068ff2b51042a8b957bb98841cd1ff401ac086b912d7f1e"
    sha256 cellar: :any,                 sonoma:        "2f9c0629e5477f9c26ab3e9194ccac654a4b219142cc64eac42a047800adfc51"
    sha256 cellar: :any,                 ventura:       "489d0db6a88503788b7f88d9b1a5655512644080e903647f69399fe8ccf553b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2436b71b103298053c581948242dee085e98856400d1b8f7bb3b833b36c78f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5dc9ed6f0e744c483e731a22145f0456f3b46f967177e176cdd1d14c0b20170"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import sys
      from pathlib import Path

      import fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    PYTHON

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_path_exists out_png
  end
end
