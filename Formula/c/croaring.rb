class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.8.tar.gz"
  sha256 "7586262e70630e63b4513806498ebf9464168fdd6ada6e14f2aca568951fd1a5"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a64d015df447d2b2e0e913ab8300193dff375801268aa42030714972697350b2"
    sha256 cellar: :any,                 arm64_sonoma:  "09097ef4eda5aba34f2674182686868639ca9c39c2f80d03633c5b00f9fc1512"
    sha256 cellar: :any,                 arm64_ventura: "93a2aca4f41853eed09cdee9e57a1ce90156f262b80dfda76a2e8a9f8b8d82e3"
    sha256 cellar: :any,                 sonoma:        "f0d04ab6510ce7fdab7044423b659f8ead884f660894904e735821dab21a56d8"
    sha256 cellar: :any,                 ventura:       "a6ac14c3459fb9904143c012e7b5e7eee35a4771e8c0fce2131632393af640a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373fd59375fc0f5aa18a975ba667e593fca4f8a5c0b39695d8a118c0ebbe2c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21b9c757f253f42a2adf87c819fb02bcdeb5910a00d540b89952b4acf13f6325"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DROARING_BUILD_LTO=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
