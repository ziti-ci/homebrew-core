class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.net/"
  url "https://github.com/dharple/detox/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "409c25875da37137a390d29a65d0cadcf99c4f6fe524fdb76bc1fb7e987ab799"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "2c8a32673686361bf04898306888ae65718b6ef6408c63c0b4fa711ee4b36b0a"
    sha256 arm64_sonoma:  "436c94eec6c569db314807a3314dc4ea389ceb662db9e191a48d0d63eaad3180"
    sha256 arm64_ventura: "4674f7f96d48d0ce435d866b8f61090ff55cc531199a7defd30e46cb49a777ac"
    sha256 sonoma:        "0bd23f28b3a788dfae5fe7297a6375338a382a1f7c5759d5dc3f49255bf23f35"
    sha256 ventura:       "e32a97460e895f3a311c0aa1f3ce6cb812e943916256735cdd507700fdf700e5"
    sha256 arm64_linux:   "478e21e6feedf75fe43bafea397d6e9a5cc100ad7014092ce342399d45728bc3"
    sha256 x86_64_linux:  "7bdb9b90e06c87c3ed666a8324133e48d372db477bdf73f845962fa0b53e8f6f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
