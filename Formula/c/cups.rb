class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.14/cups-2.4.14-source.tar.gz"
  sha256 "660288020dd6f79caf799811c4c1a3207a48689899ac2093959d70a3bdcb7699"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "76d34f500a5b78cb5ffaa2a1bc1e86fd311b09ac320a5b84801bc99476a2bb71"
    sha256 arm64_sonoma:  "92b54d896f2e162a2bfd09900d37f9a9f5f70ff034b889d7438ff486136ef020"
    sha256 arm64_ventura: "159feb431684706b02fc426d6ca1f0873d977cb10f3b2859ce32aa6eb27af42e"
    sha256 sonoma:        "e828cd3f54a34644fa7956dcbefb1c3a4632cfd088942c4e1284395b002399e6"
    sha256 ventura:       "52f2e22e318e86be801f33224f294cb0f6a9b1d128ca61f960213b3a13e90cdc"
    sha256 arm64_linux:   "2fff676be7015b70281d75eca4df1b4c9386ae844b116203c637381b743ed145"
    sha256 x86_64_linux:  "a55866d0be06c40834a291dfc51adafd9b7aa63aeb1a6bafe6a72124475a2c35"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    system "./configure", "--with-components=core",
                          "--with-tls=openssl",
                          "--without-bundledir",
                          *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = spawn "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"

    begin
      sleep 2
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
