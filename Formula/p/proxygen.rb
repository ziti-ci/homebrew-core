class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.09.01.00/proxygen-v2025.09.01.00.tar.gz"
  sha256 "f8602dfd40e4d2a72726c5f63cc430a6abac7e72fa005739be695b3d5d4fc31e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "6bb39c37508260f20776ded6d8542b966dcc57855f067aa0bab6da8a425fcef7"
    sha256                               arm64_sonoma:  "19cbde3ce930b7a9150a87cfbd67bb73fb6320436d5466d7d5762a525b386ad3"
    sha256                               arm64_ventura: "6d525af161582983242795d367b32f0cbc1d8edaad4632a6a09e64c426b09d41"
    sha256 cellar: :any,                 sonoma:        "5c5694ffc6401602394ab1227231cd38071f6c545a41e3933659da51988a9e3a"
    sha256 cellar: :any,                 ventura:       "bf12c14c6124f089c6b6821803e7a61ab9e697acb475e68d5e6472d4e3882cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0cb2b7dcdbb48a2d49b034f6b4ef5750cd0b57dfcb9370ca3b1efd4b77e8ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ddf97e3cbb525994f69c0cbd4e530dedc266b819d4438ab092e01ac13f2404"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "c-ares"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix name of `liblibhttperf2`.
  # https://github.com/facebook/proxygen/pull/574
  patch do
    url "https://github.com/facebook/proxygen/commit/415ed3320f3d110f1d8c6846ca0582a4db7d225a.patch?full_index=1"
    sha256 "4ea28c2f87732526afad0f2b2b66be330ad3d4fc18d0f20eb5e1242b557a6fcf"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/proxygen/pull/570
  patch :DATA

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end

__END__
diff --git i/CMakeLists.txt w/CMakeLists.txt
index cc189df..9d61345 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -80,17 +80,21 @@ find_package(ZLIB REQUIRED)
 find_package(OpenSSL REQUIRED)
 find_package(Threads)
 find_package(c-ares REQUIRED)
-find_package(Boost 1.58 REQUIRED
-  COMPONENTS
+set(PROXYGEN_BOOST_COMPONENTS
     iostreams
     context
     filesystem
     program_options
     regex
-    system
     thread
     chrono
 )
+find_package(Boost 1.58 REQUIRED COMPONENTS ${PROXYGEN_BOOST_COMPONENTS})
+if (Boost_MAJOR_VERSION EQUAL 1 AND Boost_MINOR_VERSION LESS 69)
+    list(APPEND PROXYGEN_BOOST_COMPONENTS system)
+    find_package(Boost 1.58 REQUIRED COMPONENTS ${PROXYGEN_BOOST_COMPONENTS})
+endif()
+string(REPLACE ";" " " PROXYGEN_BOOST_COMPONENTS "${PROXYGEN_BOOST_COMPONENTS}")
 
 list(APPEND
     _PROXYGEN_COMMON_COMPILE_OPTIONS
diff --git i/cmake/proxygen-config.cmake.in w/cmake/proxygen-config.cmake.in
index 8899242..114aaf7 100644
--- i/cmake/proxygen-config.cmake.in
+++ w/cmake/proxygen-config.cmake.in
@@ -31,16 +31,7 @@ find_dependency(Fizz)
 find_dependency(ZLIB)
 find_dependency(OpenSSL)
 find_dependency(Threads)
-find_dependency(Boost 1.58 REQUIRED
-  COMPONENTS
-    iostreams
-    context
-    filesystem
-    program_options
-    regex
-    system
-    thread
-)
+find_dependency(Boost 1.58 REQUIRED COMPONENTS @PROXYGEN_BOOST_COMPONENTS@)
 find_dependency(c-ares REQUIRED)
 
 if(NOT TARGET proxygen::proxygen)
