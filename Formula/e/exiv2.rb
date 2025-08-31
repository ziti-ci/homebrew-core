class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.7.tar.gz"
  sha256 "5e292b02614dbc0cee40fe1116db2f42f63ef6b2ba430c77b614e17b8d61a638"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f537afa528f07f59e211328782bd179ab600c32638fc84116183f77641e271b"
    sha256 cellar: :any,                 arm64_sonoma:  "8a4ec3e4f1f6f4d1922e80478694249f600cc505cb4439cea7a672b2205b3869"
    sha256 cellar: :any,                 arm64_ventura: "cb7eabc13fd1075bad1a45e12e68e052bca0debedb02a96fe226f3b79f4bbc02"
    sha256 cellar: :any,                 sonoma:        "82912857ee9f3a4e30629ae5cdca1e97cb7cd3bcce64c24e4aaa91a5da88cdc0"
    sha256 cellar: :any,                 ventura:       "c3f4889ea710f700d52c604bec981a61be88be57955cc5ef7116e94345ce9836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ea2a8e6084d4cdb1c6e37fb332ba75d4ad645342d1ff1ee10ae57ac69c77e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36dbfa0937c5874264157be32afd01118275e581e056ed4a1b79115900aee33"
  end

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build # for msgmerge
  end

  def install
    args = %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_ENABLE_BMFF=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
