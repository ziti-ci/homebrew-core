class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.7.0.tar.xz"
  sha256 "45dc0396060c863169868349ec280af1c6f4ac524aa492580e1a065e142c2cd8"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b333b588588d4d5d7f7c14be493a09f0c541639add4e69f180fb74e9cb029fad"
    sha256 arm64_sonoma:  "34049148e5e982ce687c01fed23e89a6ae5eeccee8251f59e9fa3c787f42749c"
    sha256 arm64_ventura: "650d7c6c78c2b7bb8310e5f8ef99e4e292bdc76e7a0059fa78b5c409f1c5f8d2"
    sha256 sonoma:        "14b00b6ab38361c24c665060103b64c7d9ecd5a3c6e01342d5cbfccd31f8cb22"
    sha256 ventura:       "1cac654fd2c809f30e6019a4b71b78592d587297c9e5e066dc34d8bafcaa6338"
    sha256 arm64_linux:   "3a38a63283d50f8d0eefc5fbc7bd0c65d8c8be35f5e00d0de3ca7c76c6700acb"
    sha256 x86_64_linux:  "39721b0a72bea7690cb0d0552ca338deb24f4336f64a0e3168a24cb19e340a45"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  def install
    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end
