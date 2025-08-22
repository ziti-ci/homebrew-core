class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.30.0.tar.gz"
  sha256 "9cf4727526d988cee62705f29f53c21765838302713ed6e6c0b29ac117c66af5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "be36bdaad3510fc56343d42b0fc7038d9341c4ae9e0ce27cc51f6a793abf5b3a"
    sha256 cellar: :any,                 arm64_sonoma:   "994e52bf99877c30b8e1dff40cb68b15107837c98f81f0dc4bae9ac4b7996270"
    sha256 cellar: :any,                 arm64_ventura:  "316c3597188922ed828074195528feddb5e1dde7729c5d95171f42cedf12ef3e"
    sha256 cellar: :any,                 arm64_monterey: "f9b2117f8e9af15c7f2daa38462b5eb20c5016698969bc320eb3129faa928ad3"
    sha256 cellar: :any,                 sonoma:         "774795c0281215f51a2bd98e1310de9777ff88d44c812c7b4bf747915215aeae"
    sha256 cellar: :any,                 ventura:        "a5fae3ac3b3c576f4f5a0b84b2f213251963eee770f94cd486b26f5122dd3513"
    sha256 cellar: :any,                 monterey:       "8a2e86e7e6492f65534900bf6dee5bbff26ca910df3db5113b31d9393fccd710"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c7e25093e68309582dbad8c1d255f38c74196379ecc77dce91c9c1d8d1e4e744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe8c6c3991ddf495a9b1d393818204927ab07da57de6ca47c3177197bded579"
  end

  depends_on "libjodycode"
  depends_on macos: :catalina # requires aligned_alloc

  def install
    # error: no member named 'st_mtim' in 'struct stat'
    inreplace "filestat.c" do |s|
      s.gsub! "st_mtim.tv_sec", "st_mtime"
      s.gsub! "st_atim.tv_sec", "st_atime"
    end

    system "make", "ENABLE_DEDUPE=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zero-match .").strip.split("\n").sort
    assert_equal ["a", "b"], dupes
  end
end
