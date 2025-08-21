class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.6.0.zip"
  sha256 "be21c9779b8f048f0427042d6e36cb08aed75eb943b8c60a1bc064a84788273c"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37630fd09733c60ce21471bd08217aea720309a028910e5130e58b858aa2426"
    sha256 cellar: :any_skip_relocation, ventura:       "f37630fd09733c60ce21471bd08217aea720309a028910e5130e58b858aa2426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e626d2b1fc49db2e10550bbd6886259802b4c1c26f0ee637189e51d3c68bfda"
  end

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end
