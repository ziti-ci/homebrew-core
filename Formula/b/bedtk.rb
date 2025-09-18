class Bedtk < Formula
  desc "Simple toolset for BED files"
  homepage "https://github.com/lh3/bedtk"
  url "https://github.com/lh3/bedtk/archive/refs/tags/v1.2.tar.gz"
  sha256 "c0e1f454337dbd531659662ccce6c35831e7eec75ddf7b7751390b869e6ce9f0"
  license "MIT"

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bedtk"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    system bin/"bedtk", "flt", "test-anno.bed.gz", "test-iso.bed.gz"
  end
end
