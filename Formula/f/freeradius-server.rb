class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_8.tar.gz"
  sha256 "7a42562d4c1b0dfd67783b995b33df6ea0983573b2a3b2b99c368dda647e562c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_sequoia: "b9243e933ae4e539f4d8c824db8fe7af52bb72486ccb6e3af8632da30085dd6f"
    sha256 arm64_sonoma:  "149184cc524e08083c8ec2a51a2304760c8b2b95788340b3eac9699e35da85f8"
    sha256 arm64_ventura: "486bfc00d5ca794823113992d3dfdcc3e50550349f29bf18e6e4bceea8e5bee3"
    sha256 sonoma:        "232c9f0921fca5bf3df3b612f8dd451c8d61a6b7ce2be45a7a7037d014f5d196"
    sha256 ventura:       "64ce4c5828bb09fbf4c505f16190e08b0ee47350f6fd9ae25885cfea40587a0a"
    sha256 arm64_linux:   "d368ba93b23f1d666d39c270653aca11a68ae234f090935be4072e6fb32a6db2"
    sha256 x86_64_linux:  "8c63ede2e929cf56b024600c54c5595c694f0a8852aef432f5905c558db5cf81"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gdbm"
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end
