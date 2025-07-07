class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.7.2/apache-pulsar-client-cpp-3.7.2.tar.gz"
  sha256 "e4eee34cfa3d5838c08f20ac70f5b28239cb137bb59c75199f809141070620dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17409dae5bc4dfeae755a2e7ebc4d0e255a56f12f6c8d658a8f631cdbfe35bec"
    sha256 cellar: :any,                 arm64_sonoma:  "054c0c3c347a1b55e64eb24978acaf7fdfb72162ed35277f4bf16093a2e1a3ff"
    sha256 cellar: :any,                 arm64_ventura: "1e28e6732875416affdcc4afc3763e798882dd589424e168bb67bd7517411c6d"
    sha256 cellar: :any,                 sonoma:        "f87f6563fb986d754764ec158a2deddded5cbfef795bd67c52f83ae0a72e8e8b"
    sha256 cellar: :any,                 ventura:       "3061a6de50f7659f859917ad16f20f0e9b312efa90d7123533534ad3a60111e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5054b692852656ba4580739f5ec8ba057f330c1e15ca36196277c4688b8cac17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2438a72ed70e421eae87a6e3fa2c4db58d3f4e7ec8b1bce6893421546c533d95"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
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
