class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://github.com/thestk/rtaudio"
  url "https://github.com/thestk/rtaudio/archive/refs/tags/6.0.1.tar.gz"
  sha256 "7206c8b6cee43b474f43d64988fefaadfdcfc4264ed38d8de5f5d0e6ddb0a123"
  license "MIT"
  head "https://github.com/thestk/rtaudio.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "91a97a9e4ed02b0fef4016d7ee2916edce3c41251bf9942f4aef4a9148c382f3"
    sha256 cellar: :any,                 arm64_sonoma:   "1d56ffbaacd143c4ce5215d42f5424d42dfd947bc26eaf57830eb51e7546068b"
    sha256 cellar: :any,                 arm64_ventura:  "483296d1cc1b969448614c1a22d004a1222270832842dce62be151465fd21753"
    sha256 cellar: :any,                 arm64_monterey: "87c6a5b3c3eeb5b176786c650f5606de4cf7936ddf152fb669456eca491512cb"
    sha256 cellar: :any,                 sonoma:         "0a25a53c7f0cf7dc23dc4e4e9ecaa7df13051b16b3c8513ece3609064a74bab1"
    sha256 cellar: :any,                 ventura:        "a3feed53dc08f1210bd32431b16fc0bf0264dc66144ea64716b95b9a34e80902"
    sha256 cellar: :any,                 monterey:       "fb3184319287e1a9d056b35033806116fd44390f406cc3a19f2d9fc107148318"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5fd5758c63b71ddcc39884b1eabc5408bb4e25c812bf94a7021df35aba3f9881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5115ee3bbfff48c47089c8051a0826ce35277e2d75397cb8e1b0fe39e8933588"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure"
    system "./configure", *std_configure_args
    system "make", "install"
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tests/testall.cpp", "-o", "test", "-std=c++11",
           "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio"
    system "./test"
  end
end
