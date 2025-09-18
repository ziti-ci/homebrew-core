class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.13.2/lnav-0.13.2.tar.gz"
  sha256 "2b40158e36aafce780075e05419924faf8dd99d1c0d4ae25a15b00bc944f4d60"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f683d861edfd0d472409c9e54dc97e877169e56baf7f8fba6824545e9ed4918"
    sha256 cellar: :any,                 arm64_sequoia: "67680a240a10e7caf6e865cabd617cbbc77c97f5e4b8f257ed5519d2180e6e25"
    sha256 cellar: :any,                 arm64_sonoma:  "aceeaf1385343eb892e38e3d666f2d09eee08e2fd9861029cbd0b5541ff2b252"
    sha256 cellar: :any,                 arm64_ventura: "ce354f9f3295c7f420404b7bf03a3fe08fd4cab96f11b0d2584b8c3bc52b6274"
    sha256 cellar: :any,                 sonoma:        "fb303c355d05bce93e717b7ae7e5e528d487d0d1b2d33206fd3205dc820c1ab9"
    sha256 cellar: :any,                 ventura:       "7b3082e00ea9c2de8a67144eb584f747003787eb0939ce725e057a7ec1653339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e9aafedef046e6f7cc01bc142280f37f0aa7569bb5b24e5454739592fedb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee12bf35f2a62221aaef14d354b626a3bf20cc715876da1b2027cbcb6c8ade47"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "re2c" => :build
  end

  # TODO: Make autoconf and automake build deps on head only upon next release
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "rust" => :build
  depends_on "libarchive"
  depends_on "libunistring"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
