class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "a5cdbf0e8b5198a0f0e863e9f9e3c35b30a78b189c2cd2f300d2d3ca67c0aa3f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4e759345fdf877e02b605efeaf3eaa16e43a83addb6c5bb726f32b922b61bef"
    sha256 cellar: :any,                 arm64_sonoma:  "4b971755b7aa91817395ac0bdb49689809746a3a2653df44124726a4c10bc710"
    sha256 cellar: :any,                 arm64_ventura: "7825b4cc841ec6bc93a3c2c55df516a519c685df7f309f0a28f19a597e60204b"
    sha256 cellar: :any,                 sonoma:        "fa05030f67e26ef277265c5b967a9e76ffd1973e7c0d488dea3310f42ea3884f"
    sha256 cellar: :any,                 ventura:       "5ce5de03c92c5b50b8ead58eaee3f2b2d118b44a3adbd39ef95fb274461836c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e63128f38e72b70b4caccd116c71e1739da6db2ce7a3dffc9fd54ab98dcab316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c780f8d459efdf69b3adbd9403de57dfbbc160b1eb8bc2190cc362181c4fc8d4"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  # Workaround for Boost 1.89.0 until upstream fix.
  # Issue ref: https://github.com/facebook/folly/issues/2489
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~CPP
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMake/folly-config.cmake.in b/CMake/folly-config.cmake.in
index 0b96f0a10..800a3d90b 100644
--- a/CMake/folly-config.cmake.in
+++ b/CMake/folly-config.cmake.in
@@ -38,7 +38,6 @@ find_dependency(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
diff --git a/CMake/folly-deps.cmake b/CMake/folly-deps.cmake
index 7dafece7d..eaf8c2379 100644
--- a/CMake/folly-deps.cmake
+++ b/CMake/folly-deps.cmake
@@ -41,7 +41,6 @@ find_package(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
