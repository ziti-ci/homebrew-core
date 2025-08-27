class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  license "ISC"
  revision 1
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  stable do
    url "https://github.com/vgmstream/vgmstream.git",
        tag:      "r2023",
        revision: "f96812ead1560b43ef56d1d388a5f01ed92a8cc0"
    version "r2023"

    # Backport CMake install support
    patch do
      url "https://github.com/vgmstream/vgmstream/commit/e4a00bc710e99c29b6a932ec353d8bc6ba461270.patch?full_index=1"
      sha256 "9ee47e5b35e571a9241bcab6ebe8ae09ecffde72702cacb82b4e93f765813e0b"
    end
  end

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "04e3f32a4e72f77e1a87d467bd043437b3d3e16b1c9a3257925a90b5969f0fc8"
    sha256 cellar: :any,                 arm64_sonoma:  "2764fb3e7612cb5e3471c6c66e012434f42f1e88183327f41e0ea20039dbeba5"
    sha256 cellar: :any,                 arm64_ventura: "8496fb62b6fced555786fb142f6d783d98deddb0ee0873ed51d34ab673e5d951"
    sha256 cellar: :any,                 sonoma:        "b55ad40f1dfc8b1dcf4c967eb196d55a6e33518513ff3a77ed3520a96637e009"
    sha256 cellar: :any,                 ventura:       "95c9ed7d5514151bdeecc33c93353b7cee6196e5e96279a49cca2ae3eea13185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebd1f3823dc9561171b3df3acbd6e2560aa13d0cfb7d2b7c221aa2e1e4fbb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98268d17d6f3652d71b301a442efc2b3540d93c6ca46313a3f67e51f67162ef"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "speex"

  on_macos do
    depends_on "libogg"
  end

  # Apply open PR to support FFmpeg 8
  # PR ref: https://github.com/vgmstream/vgmstream/pull/1769
  patch do
    url "https://github.com/vgmstream/vgmstream/commit/3e12a08a248cfb06f776b746238ee6ba38369d02.patch?full_index=1"
    sha256 "4d0eed438f24b0dd8fa217cf261cf8ddb8e7772d63fc51180fe79ddceb6a8914"
  end

  def install
    # TODO: Try adding `-DBUILD_SHARED_LIBS=ON` in a future release.
    # Currently failing with requires target "g719_decode" that is not in any export set
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_AUDACIOUS:BOOL=OFF",
                    "-DUSE_CELT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install "build/src/libvgmstream.a" # remove when switching to shared libs
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
