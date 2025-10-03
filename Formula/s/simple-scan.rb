class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/49/simple-scan-49.0.1.tar.xz"
  sha256 "e19762422663ef4bf5d39f6e75f4d61a8de1813729a96e57e04e81764e01eae2"
  license "GPL-3.0-or-later"

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f937bf1be2f3901e778021bc960df2cba46ea8620194d0921294074b51493256"
    sha256 arm64_sequoia: "d9ee5af3be73580ad426781dfa25a40519e2c47bfe3587ea66d052e5e616fde8"
    sha256 arm64_sonoma:  "8ee479bab008f04c79439fff0b4983ee0332a803fcea3210084670a016d33440"
    sha256 arm64_ventura: "12bcf57abadcc279db5ec1ee6d5e4200bd923b99441e9606d4d5f4956d313b9d"
    sha256 sonoma:        "c71ba4f70d2d512ee6195ae3164ef00994034581e3f370dead655ee418b87a3d"
    sha256 ventura:       "f47bad169d41838ee33e0a2e00dd791c1ff1cd48f8de2395ffafc3e0793f15d2"
    sha256 arm64_linux:   "4b07b69954306f03d6f77c41d58e078e185b0e35c13ad81f61c74f62ffcbf0ab"
    sha256 x86_64_linux:  "2cf9490d0d33b08c68a7c73a69fc78fb160a00f9c8a1bb593d084d53047ce12b"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/GNOME/simple-scan/-/issues/386
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"simple-scan", "-v"
  end
end
