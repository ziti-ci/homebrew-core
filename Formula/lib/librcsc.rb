class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2024.tar.gz"
  sha256 "81a3f86c9727420178dd936deb2994d764c7cd4888a2150627812ab1b813531b"
  license "LGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3d9d528cd8cfa66f49e6a5a371a4f93a2ceac383985a9189627bfd901006b9c7"
    sha256 cellar: :any,                 arm64_sonoma:  "8fde29d988114c1ad006242a6e5ff6d76da689505116521fd8581c44f3c1f6b1"
    sha256 cellar: :any,                 arm64_ventura: "2ef3bfaa135d7dcdfa214b56ec141bdac11882fb307a6aaa4415fda4a982aad8"
    sha256 cellar: :any,                 sonoma:        "d4887f6f0256c8c55347ef86c671a712b3b8b07e52ff691899197a4ecb40ac90"
    sha256 cellar: :any,                 ventura:       "d91b3e133981705b317d6a74a48f821a13c3e83d1ea53f27a8b087c6087cfe2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a6bd68f775c4ca1091551b26fed7f25c9a00538ca9b29eec04282835d3c425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77dd0bd9e1b3c8971a4eca3430b49648f944824d1a6fc0337696c846372ca9b2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "nlohmann-json" => :build
  depends_on "simdjson"

  uses_from_macos "zlib"

  # Add missing header to fix build on Monterey
  # Issue ref: https://github.com/helios-base/librcsc/issues/88
  patch do
    url "https://github.com/helios-base/librcsc/commit/3361f89cf9bb99239a7483783b86de1648d5f359.patch?full_index=1"
    sha256 "cd9df87f8f8dd0c7e3dd0a0bf325b9dd66f8ba9e42cb0e6fab230872dc5ce243"
  end

  # Unbundle simdjson
  patch :DATA

  def install
    # Remove bundled nlohmann-json and simdjson
    rm_r(["rcsc/rcg/nlohmann", "rcsc/rcg/simdjson"])

    # Workaround until upstream removes unnecessary Boost.System link
    boost_workaround = ["--without-boost-system"]

    # Strip linkage to `boost`
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *boost_workaround,
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc"
    system "./test"
  end
end

__END__
diff --git a/rcsc/rcg/Makefile.am b/rcsc/rcg/Makefile.am
index 819c63a..4bac46f 100644
--- a/rcsc/rcg/Makefile.am
+++ b/rcsc/rcg/Makefile.am
@@ -6,7 +6,6 @@ noinst_LTLIBRARIES = librcsc_rcg.la
 #lib_LTLIBRARIES = librcsc_rcg.la
 
 librcsc_rcg_la_SOURCES = \
-	simdjson/simdjson.cpp \
 	handler.cpp \
 	parser.cpp \
 	parser_v1.cpp \
@@ -47,9 +46,10 @@ librcsc_rcginclude_HEADERS = \
 	types.h \
 	util.h
 
-noinst_HEADERS = \
-	simdjson/simdjson.h
+noinst_HEADERS =
 
+librcsc_rcg_la_CXXFLAGS = -DSIMDJSON_THREADS_ENABLED=1
+librcsc_rcg_la_LIBADD = -lsimdjson
 librcsc_rcg_la_LDFLAGS = -version-info 6:0:0
 #libXXXX_la_LDFLAGS = -version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)
 #		 1. Start with version information of `0:0:0' for each libtool library.
@@ -76,8 +76,7 @@ AM_CFLAGS = -Wall -W
 AM_CXXFLAGS = -Wall -W
 AM_LDFLAGS =
 
-EXTRA_DIST = \
-	simdjson/LICENSE
+EXTRA_DIST =
 
 CLEANFILES = *~
 
diff --git a/rcsc/rcg/parser_simdjson.cpp b/rcsc/rcg/parser_simdjson.cpp
index 019d482..a5eca8c 100644
--- a/rcsc/rcg/parser_simdjson.cpp
+++ b/rcsc/rcg/parser_simdjson.cpp
@@ -39,7 +39,7 @@
 #include "types.h"
 #include "util.h"
 
-#include "simdjson/simdjson.h"
+#include "simdjson.h"
 
 #include <unordered_map>
 #include <string_view>
