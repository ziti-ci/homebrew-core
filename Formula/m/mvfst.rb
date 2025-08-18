class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://github.com/facebook/mvfst/archive/refs/tags/v2025.08.18.00.tar.gz"
  sha256 "8906b8e7e517a5676d1ab1288ca0566e4bbaa87f484af258c9e2f59e682be91b"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "88b81f899678252ddc2731fc2ca653c409d21f945253d9224215a3824db019c6"
    sha256                               arm64_sonoma:  "033ec7b6024d085e7d6170ca00a9207c20fe2e79b977140d7fbe4f22cbb6437d"
    sha256                               arm64_ventura: "5c9087cfe7080dbd80b1119a6f425668ae3e47fffa6e4d4c65575feb019f5282"
    sha256 cellar: :any,                 sonoma:        "a38be2b3f090f84913e8414aec2441d0075e78cac1dba8b2bc0f2a7dde834f60"
    sha256 cellar: :any,                 ventura:       "bd392f5224a8c02cb47f53b77171657274b1777e9dd84af9171c5f5ebfbb2e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d64ec398e6c25cc9f777d3928cf7215683f0ae0475d4deeffdadb8ac25c42c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16eab43b9dfccabd23dd8e6227e4ef120b5a3ea44bd8e24d2f11d380f88fed8d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/mvfst/pull/405
  patch do
    url "https://github.com/facebook/mvfst/commit/77dfed2a86bd2d065b826c667ae7a26e642a61d9.patch?full_index=1"
    sha256 "182e642819242a9afe130480fc7eaee5a7f63927efa700b33c0714339e33735c"
  end

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_TESTS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    ENV.delete "CPATH"
    stable.stage testpath

    (testpath/"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quic/samples/echo/main.cpp
        quic/common/test/TestUtils.cpp
        quic/common/test/TestPacketBuilders.cpp
      )
      target_link_libraries(echo ${mvfst_LIBRARIES} fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
      set_target_properties(echo PROPERTIES BUILD_RPATH "#{lib};#{HOMEBREW_PREFIX}/lib")
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    server_port = free_port
    server_pid = spawn "./build/echo", "--mode", "server",
                                       "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      "./build/echo", "--mode", "client",
                "--host", "127.0.0.1", "--port", server_port.to_s
    ) do |stdin, _, stderr, w|
      stdin.write "Hello world!\n"
      Timeout.timeout(60) do
        stderr.each do |line|
          break if line.include? "Client received data=echo Hello world!"
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  ensure
    Process.kill "TERM", server_pid
  end
end
