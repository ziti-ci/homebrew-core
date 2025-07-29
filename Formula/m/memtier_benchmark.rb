class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.1.4.tar.gz"
  sha256 "11a16ce32bc96a21511ee38da5e10bec4b50323ff6735909c014e040b60f4db7"
  license all_of: [
    "GPL-2.0-only",
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memtier_benchmark --version")
    assert_match "ALL STATS", shell_output("#{bin}/memtier_benchmark -c 1 -t 1")
  end
end
