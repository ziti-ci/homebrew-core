class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.1/freetype-2.14.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.1.tar.xz"
  sha256 "32427e8c471ac095853212a37aef816c60b42052d4d9e48230bab3bdf2936ccc"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4098ab831ed303d161a7e1ad5f2f9fdc2ffd29a08e370ef7ebfe1716d38d1f14"
    sha256 cellar: :any,                 arm64_sequoia: "3316a38555210e86a126f81840d32ed6a0a3e2dfac5bd4d0a407dfeb6a2b97b7"
    sha256 cellar: :any,                 arm64_sonoma:  "59c1b6678e6132a21ddea51e9b9f53ed087512bdd3c398f56da396d2e54d62ff"
    sha256 cellar: :any,                 arm64_ventura: "18bfcee156c39d5d5b2d5d7237503878de88fb45b9d1a6707fb8e48a58e11ea2"
    sha256 cellar: :any,                 sonoma:        "31703ac37b0205c61bd90786498d6f6ab08352238152eab899b4f37674a3b151"
    sha256 cellar: :any,                 ventura:       "2b49e12c5195cfeb876193766ae97b1a5c2f47c9928711872e280d2ff5bba1ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8497f71b32c54e0679d1f6a7e60abedd7d6658ba381b70b4a65fb2b7075213b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574a04ba374677b57ad84db97602edd8d292bca70c9dca3d0bb8111f6a231064"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
