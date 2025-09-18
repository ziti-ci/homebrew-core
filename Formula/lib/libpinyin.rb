class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/refs/tags/2.10.3.tar.gz"
  sha256 "a49286721fb2b0234d86c095db9226246b0aa4a0bb6a885d0902da2743c56476"
  license "GPL-3.0-or-later"

  # Tags with a 90+ patch are unstable (e.g., the 2.9.91 tag is marked as
  # pre-release on GitHub) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c3eff6787b4bc6cbf0e273a6ba581d8f3e084d446b2c80c6c67e4d6604461a05"
    sha256 cellar: :any,                 arm64_sequoia: "699b9d73d9a1b5d16bddc316b6bc1318438ebfa7c690a55d0a62d1eaea44e723"
    sha256 cellar: :any,                 arm64_sonoma:  "873af165cb45fd26a2c2530c25d0b9a2e069735d91c259552a3e15bd7b56f952"
    sha256 cellar: :any,                 sonoma:        "55db6b57140725c04486323779e41975236593d7d0653cdbe8fed500a5f9e0f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad69490dffe944746572abc03f9fac9a07729271e7f00be47083d7afc6dd78d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e96c07a3b59e86a4f372d0fc46d534571901e89d713f6218ac8baa00eae3f13"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"

  on_macos do
    depends_on "berkeley-db"
    depends_on "gettext"
  end

  on_linux do
    # We use the older Berkeley DB as it is already an indirect dependency
    # (glib -> python@3.y -> berkeley-db@5) and gets linked by default
    depends_on "berkeley-db@5"
  end

  # The language model file is independently maintained by the project owner.
  # To update this resource block, the URL can be found in data/Makefile.am.
  resource "model" do
    url "https://downloads.sourceforge.net/libpinyin/models/model20.text.tar.gz"
    sha256 "59c68e89d43ff85f5a309489499cbcde282d2b04bd91888734884b7defcb1155"
  end

  def install
    resource("model").stage buildpath/"data"
    system "./autogen.sh", "--enable-libzhuyin=yes", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pinyin.h>

      int main()
      {
          pinyin_context_t * context = pinyin_init (LIBPINYIN_DATADIR, "");

          if (context == NULL)
              return 1;

          pinyin_instance_t * instance = pinyin_alloc_instance (context);

          if (instance == NULL)
              return 1;

          pinyin_free_instance (instance);

          pinyin_fini (context);

          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs libpinyin").chomp.split
    system ENV.cxx, "test.cc", "-o", "test", "-DLIBPINYIN_DATADIR=\"#{lib}/libpinyin/data/\"", *flags
    touch "user.conf"
    system "./test"
  end
end
