class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "9f99bb89876510435fbfc47bbc8653bc57e736a21915ec0404e0610460756cb8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5deb48f92012192c44f815dd4956b65b586138a5407ee247aa8a2aee487993ab"
    sha256 arm64_sequoia: "68eb4e14acfe84c6f2964e5412b7e7a8b7f6363ca7e4018866b141311275c42a"
    sha256 arm64_sonoma:  "2dff3fe7b5c36f2a7531a85bb073a8c15c264d68684d4ea20cefcc8ce46f11a5"
    sha256 sonoma:        "f685dd040434e3335c41f1ab5104db5baa96243fda0a715e8087e3873c5049cd"
    sha256 arm64_linux:   "04bcc2da98a252bebdd8b6206957de9b5d4409c58fe2533197fcc6b3a71eed5f"
    sha256 x86_64_linux:  "684b1f7d95352c1d14a3a9431c7cccf4e5326e6e80c517d092afd8bd7d860fdf"
  end

  uses_from_macos "zlib"

  def install
    args = ["ZLIB=yes", "DNS=yes", "SHARED=yes", "PREFIX=#{prefix}", "MANDIR=#{man}"]
    system "make", *args
    system "make", "install", *args
    system "make", "install-lib", *args
  end

  test do
    lspci = (OS.mac? ? sbin : bin)/"lspci"
    assert_match "lspci version", shell_output("#{lspci} --version")
    if OS.mac?
      assert_match "run as root", shell_output("#{lspci} 2>&1", 1)
    else
      assert_match(/Host bridge:|controller:/, shell_output(lspci))
    end
  end
end
