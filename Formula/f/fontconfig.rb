class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.17.1/fontconfig-2.17.1.tar.gz"
  sha256 "82e73b26adad651b236e5f5d4b3074daf8ff0910188808496326bd3449e5261d"
  license "MIT"
  head "https://gitlab.freedesktop.org/fontconfig/fontconfig.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+\.\d+\.(?:\d|[0-8]\d+))/i)
  end

  bottle do
    sha256 arm64_sequoia: "c3a7405dd151a87f72e7f99c95150da1fc8320ee817c3a17f15a493e1e01057c"
    sha256 arm64_sonoma:  "3ddfba863428fbb47be87178f2beaedd1a2c248724a3ce421c3f20bbecb035f1"
    sha256 arm64_ventura: "9af1bb1acad87514d53aa77cab95e15200794466c4618e9f96446b2113aa6dba"
    sha256 sonoma:        "37befec606c968bf0e3664d53a0cef5fbc013aa851f1c3d534b8f5f7a5af1de1"
    sha256 ventura:       "e09a65225015698a10e7c185d5de1d5b0976a672d57d5e8d65096b2bd03bb9fd"
    sha256 arm64_linux:   "a976210901014cc178e600d4e80df3f4d4c3bf86b67aabeacbe5fe27b8363d92"
    sha256 x86_64_linux:  "040b8c1ce9fd3d3022f26e1400b19b757cfd993da9e819c5c0956d3a38f42f00"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "json-c" => :build
    depends_on "util-linux"
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    if OS.mac? && MacOS.version >= :sierra
      font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max
    end

    args = %W[
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      -Ddoc=disabled
      -Dtests=disabled
      -Dtools=enabled
      -Dcache-build=disabled
      -Dadditional-fonts-dirs=#{font_dirs}
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system bin/"fc-cache", "--force", "--really-force", "--verbose"
  end

  test do
    system bin/"fc-list"
  end
end
