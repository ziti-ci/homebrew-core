class Litehtml < Formula
  desc "Fast and lightweight HTML/CSS rendering engine"
  homepage "http://www.litehtml.com/"
  url "https://github.com/litehtml/litehtml/archive/refs/tags/v0.9.tar.gz"
  sha256 "ef957307da15b1258a70961942840bcf54225a8d75315dcbc156186eba35b1a7"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "gumbo-parser"

  def install
    rm_r("src/gumbo")
    # FIXME: gumbo-parser doesn't have a CMake configuration file or module
    inreplace "cmake/litehtmlConfig.cmake", /^find_dependency\(gumbo\)$/, ""

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DEXTERNAL_GUMBO=ON",
                    "-DLITEHTML_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <litehtml.h>

      int main(void) {
        litehtml::css_element_selector selector;
        selector.parse("[attribute=value]");
        assert(selector.m_tag == litehtml::star_id);
        assert(selector.m_attrs.size() == 1);
        assert(selector.m_attrs[0].type == litehtml::select_equal);
        assert(selector.m_attrs[0].name == litehtml::_id("attribute"));
        assert(selector.m_attrs[0].val == "value");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}/litehtml", "-L#{lib}", "-llitehtml"
    system "./test"
  end
end
