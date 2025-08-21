class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "127f23ea8cfe8361eda6419a782f1a30e574319c59f7daddaaf5e80fda4448c4"
    sha256 cellar: :any,                 arm64_sonoma:  "0672f509cd6452e0a3b0a704406a417c53ee08feb013fe871c339431a349fd93"
    sha256 cellar: :any,                 arm64_ventura: "ccebb44c06c890b4c1c628c724fa0d2c32b0f5ad5bcca8bd4f681869b3458bc7"
    sha256 cellar: :any,                 sonoma:        "b171543333bd0b44c7091dc1ae5690645ef766695e17b8a0bd6d9861ad69e7f4"
    sha256 cellar: :any,                 ventura:       "9235b7618d27f2ac474bc0500d814dba9003448eaf4228eb630fed8b927402d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0972785e45e4ea72ed90a0274df98a5019407745dd521c172700e5b0d44a7c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ecd9b3a9368874cecaf30395dbee90e153639f7294333ba4f465e226af5a896"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf@29"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Backport of https://github.com/apache/pulsar-client-cpp/pull/477
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/93a4bb54004417c3742ca0e41183c662d9f417f5/libpulsar/asio.patch"
    sha256 "519ecb20d3721575a916f45e7e0d382ae61de38ceaee23b53b97c7b4fcdbc019"
  end

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
