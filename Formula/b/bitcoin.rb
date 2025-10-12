class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-30.0/bitcoin-30.0.tar.gz"
  sha256 "9b472a4d51dfed9aa9d0ded2cb8c7bcb9267f8439a23a98f36eb509c1a5e6974"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/crc32c, src/leveldb
    "BSL-1.0", # src/tinyformat.h
  ]
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1d61311699d38d3a69471adb9fc6789a2d6b6ccb6b325cf186500ce0bc60ae8"
    sha256 cellar: :any, arm64_sequoia: "84de602ee27ca2d2653952586d88ecc79f0d3cd5318182ff9474780bcb2f4a47"
    sha256 cellar: :any, arm64_sonoma:  "e5af87cb95089b561a98f2a13037570f1128ee427c54ec52e57f7a1ea08cfbcf"
    sha256 cellar: :any, sonoma:        "b62278e3ada8701c9a542bee64adeaf50a5c8b1aa5b7cf172f9a96ddf24aed3b"
    sha256               arm64_linux:   "d1ca6acf2612a816805f118f1625b04ba332b23f1a97d2c3febed168862207a7"
    sha256               x86_64_linux:  "b7290cd2f6e3e5b41170d1d3fd7c7460c4a715bdb97cd5205655a68c454383cc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_ventura do
    # For C++20 (Ventura seems to be missing the `source_location` header).
    depends_on "llvm" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++ 20"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.llvm_clang if OS.mac? && MacOS.version == :ventura
    args = %w[
      -DWITH_ZMQ=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system bin/"bitcoin", "test"
  end
end
