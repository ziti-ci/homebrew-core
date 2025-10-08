class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.18.3.tar.gz"
  sha256 "178a723d7039bae3ab1cef2fc93e5e8693c4184f52519c0e9a1deee93b838df1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://bindfs.org/downloads/"
    regex(/href=.*?bindfs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "83ecff2e9e51d713bf64d92a65d9e7eb3b527971752c5c9230a333abd4c1e9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a1c0beb5e01985b160b16184e0d0edb1ad741db6000f50ac8a8e9bd457985b5"
  end

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bindfs", "-V"
  end
end
