class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.3.1/wxWidgets-3.3.1.tar.bz2"
  sha256 "f936c8d694f9c49a367a376f99c751467150a4ed7cbf8f4723ef19b2d2d9998d"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e93772b20e035fad351429f7f49b9d0f19a887bfec2eaf4f9e33a117d4f12e31"
    sha256 cellar: :any,                 arm64_sonoma:  "1e3dce1b42b1406298a540ab7b6034cc44b032a9af70393fc94349d548f801fe"
    sha256 cellar: :any,                 arm64_ventura: "38155ef3ef2820d1527d80a935a5b18987911d09e9e827087a61c232c91f6ac1"
    sha256 cellar: :any,                 sonoma:        "b9228e5e7999c1598360778981f14588c9872f99d055fec471c508a79940d9d7"
    sha256 cellar: :any,                 ventura:       "81163b981057eef6a2fcca375d95f46fa95a786411cc0b0870a4bb5ef4a932f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906bc1492c2410cbbe1afeca9b22a9e316c4b5a84f92894f7e9bd5635222c482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d307b2a2e2b14ea82cc820d2ab3ef5231afa689837185e37949126a9d7d7d37c"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "webp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "libxtst"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "pango"
    depends_on "wayland"
  end

  def install
    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre libwebp].each { |l| rm_r(buildpath/"3rdparty"/l) }
    %w[expat jpeg png tiff zlib].each { |l| rm_r(buildpath/"src"/l) }

    args = [
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-svg",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-libwebp",
      "--with-opengl",
      "--with-zlib",
      "--disable-tests",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
