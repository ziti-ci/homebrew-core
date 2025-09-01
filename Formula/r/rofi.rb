class Rofi < Formula
  desc "Window switcher, application launcher and dmenu replacement"
  homepage "https://davatorium.github.io/rofi/"
  url "https://github.com/davatorium/rofi/releases/download/2.0.0/rofi-2.0.0.tar.gz"
  sha256 "f81659b175306ff487e35d88d6b36128e85a793bfb56b64fa22c62eb54c4abd0"
  license "MIT"
  head "https://github.com/davatorium/rofi.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "5c626909b1b293d203588b80ed5d8221eeabbda74a52eb1097d7c309631a45ad"
    sha256 arm64_sonoma:  "0b314c3080bb26ad2db79ead55a11c77a6c7e619203b3da7b43bdb061336c261"
    sha256 arm64_ventura: "15c48971ba5a436e4ffb87b43b6b5a5e4041024e5b3083df70d83b40b57a1177"
    sha256 sonoma:        "3d87e7e89049147de89401787624bfec3db06fd772ff6f1167d5c6e3c3f458bd"
    sha256 ventura:       "ebe1fee45adf82c9324374d2ae33eb4af4ab1454b39872a9a1ca2d2620f2b8ad"
    sha256 arm64_linux:   "162d955726717cd43a5daada701228401f9b1b3ea66e988f44c445f93da05f12"
    sha256 x86_64_linux:  "73a4c5573499a78fefd0d2a58c15ba6069bf5169b6a3064f2951c650e1dfa889"
  end

  depends_on "bison" => :build
  depends_on "check" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "libxcb"
  depends_on "libxkbcommon"
  depends_on "pango"
  depends_on "startup-notification"
  depends_on "xcb-util"
  depends_on "xcb-util-cursor"
  depends_on "xcb-util-wm"
  depends_on "xorg-server"

  uses_from_macos "flex" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # rofi is a GUI application
    assert_match "Version: #{version}", shell_output("#{bin}/rofi -v")
  end
end
