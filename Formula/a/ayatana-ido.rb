class AyatanaIdo < Formula
  desc "Ayatana Indicator Display Objects"
  homepage "https://github.com/AyatanaIndicators/ayatana-ido"
  url "https://github.com/AyatanaIndicators/ayatana-ido/archive/refs/tags/0.10.4.tar.gz"
  sha256 "bd59abd5f1314e411d0d55ce3643e91cef633271f58126be529de5fb71c5ab38"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "pango"

  def install
    args = %w[-DENABLE_TESTS=OFF]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-ido/libayatana-ido.h>
      int main() {
        ido_init();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libayatana-ido3-0.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
