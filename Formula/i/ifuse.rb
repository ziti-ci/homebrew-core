class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/refs/tags/1.2.0.tar.gz"
  sha256 "29ab853037d781ef19f734936454c7f7806d1c46fbcca6e15ac179685ab37c9c"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/ifuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "734a650c8068975a04496c7efc513167c327b7202a112698745cea919ad75a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c1e2348ff0c16c8d70685fb9112a77739aec3317e21079527dcb2abb0f99e8e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    # This file can be generated only if `.git` directory is present
    # Create it manually
    (buildpath/".tarball-version").write version.to_s

    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
