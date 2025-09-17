class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.25.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.25.0.tar.gz"
  sha256 "2dea662ee8605946852af02d2806ca64fdadedcc718eeef6b86e0b26822c36ff"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3670a3c8f1f1e082dfd57a4d85f8daed5c1cbce813313dfc38eff91f02659910"
    sha256 cellar: :any, arm64_sonoma:  "830722db294712776ea4c81401bfccbd93f81e644c60f6276d00023576f7ff3c"
    sha256 cellar: :any, arm64_ventura: "34e55212d8190c3bbda7b025b348e73ecf256c13a5df189f192118ad5f870796"
    sha256 cellar: :any, sonoma:        "a33540c79e7a183871d70981c2a2acff5526cc888d82908931f1a88ff393c7f4"
    sha256 cellar: :any, ventura:       "ef3cf79a29c5e136107d0fe21c13b4d84faa5002e4f42668816089c44b5d563e"
    sha256               arm64_linux:   "f1bc3a03e892b24b9f6cd34aaf887f48b3ed19140a682e47bad9bd4fc5c88690"
    sha256               x86_64_linux:  "0255f6921844a49dde817c77d5048dfa556d829aa0e7e0d0107c416dbae19d71"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libtool"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    # Workaround for incomplete const change which only modified declaration
    # https://git.gnunet.org/gnunet.git/commit/src/include/gnunet_testing_lib.h?id=9ac6841eadc9f4b3b1e71e2ec08e75d94e851149
    files = ["src/lib/testing/testing_api_cmd_finish.c", "src/lib/testing/testing_api_cmd_exec.c"]
    inreplace files, /\bconst struct GNUNET_TESTING_Command\b/, "struct GNUNET_TESTING_Command"

    # Workaround for htobe64 added to macOS 26 SDK until upstream updates
    # https://git.gnunet.org/gnunet.git/plain/src/include/gnunet_common.h
    ENV.append_to_cflags "-include sys/endian.h" if OS.mac? && MacOS.version >= :tahoe

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"gnunet.conf").write <<~EOS
      [arm]
      START_DAEMON = YES
      START_SERVICES = "dns,hostlist,ats"
    EOS

    system bin/"gnunet-arm", "-c", "gnunet.conf", "-s"
  end
end
