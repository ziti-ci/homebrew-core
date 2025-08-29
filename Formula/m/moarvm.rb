class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2025.08/MoarVM-2025.08.tar.gz"
  sha256 "2ad7f7de71c811420b2cbf2b859f6f54126e7862f7b2f663f6fdb00aa3e85629"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "e68f258f6b06540bb00b0ca80fbc04b5d35cb2714474d167033e88b5d698a55e"
    sha256 arm64_sonoma:  "4855c3e695fd3e8c0252135d6ea9955fd9a676ded4b7a31811e24cc567d09153"
    sha256 arm64_ventura: "704d7e8dfcb368b7081b973051236b948b01d53ed3ddae09e9b26d3799440ee7"
    sha256 sonoma:        "f7c8e1ed3ceb29a5b04b383149eb41926313a78f1b54e838ab4df538efd27d34"
    sha256 ventura:       "616450c92fc9f35f6ee8529f8c30a0e9d777270205636572af916a43c33086b8"
    sha256 arm64_linux:   "8a73637d85ffc1653e235a58ec065b3ffa231a8a52b266bb60f4b250e9f3076e"
    sha256 x86_64_linux:  "587c91b3b7ce48129dedbc0cbb5db243037ee0cbaf88d7d4d7dd699c6e6077fa"
  end

  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moor", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2025.08/nqp-2025.08.tar.gz"
    sha256 "d7d6b42834fb81feeb6b6f0dc77174ebb50b827a3897e852fae68c0ae5614638"
  end

  def install
    # Remove bundled libraries
    %w[dyncall libatomicops libtommath mimalloc].each { |dir| rm_r("3rdparty/#{dir}") }

    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-mimalloc
      --optimize
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
      --prefix=#{prefix}
    ]
    # FIXME: brew `libuv` causes runtime failures on Linux, e.g.
    # "Cannot find method 'made' on object of type NQPMu"
    if OS.mac?
      configure_args << "--has-libuv"
      rm_r("3rdparty/libuv")
    end

    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
