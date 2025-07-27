class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2025.07.26.orig.tar.xz"
  sha256 "c1b4201c9ee2f5fd934999ecaab1526edcabc1c46273f40d7dca3ade34f4cae4"
  license any_of: ["GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/usb.ids/"
    regex(/href=.*?usb\.ids[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9413cc0397707f9cd40b952779b877330609339c86bd2b66add7d8b536f3b4c6"
  end

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
