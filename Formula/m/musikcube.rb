class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later", # src/plugins/supereqdsp/supereq/
    "LGPL-2.1-or-later", # src/plugins/pulseout/pulse_blocking_stream.c (Linux)
    "BSL-1.0", # src/3rdparty/include/utf8/
    "MIT", # src/3rdparty/include/{nlohmann,sqlean}/, src/3rdparty/include/websocketpp/utf8_validator.hpp
    "Zlib", # src/3rdparty/include/websocketpp/base64/base64.hpp
    "bcrypt-Solar-Designer", # src/3rdparty/{include,src}/md5.*
    "blessing", # src/3rdparty/{include,src}/sqlite/sqlite3*
  ]
  revision 2
  head "https://github.com/clangen/musikcube.git", branch: "master"

  stable do
    url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.4.tar.gz"
    sha256 "25bb95b8705d8c79bde447e7c7019372eea7eaed9d0268510278e7fcdb1378a5"

    # Backport support for newer asio. Using resource to deal with submodule
    resource "asio.patch" do
      url "https://github.com/clangen/musikcube/commit/a5a8a4ba6e21e09185ce10b5ecb48d6bb30f3d07.patch?full_index=1"
      sha256 "58e4215a6319b625a5c11990732ebabb2622e1dc7a91d5ef48ec791db415b704"

      # Remove submodule modification as `patch` can't handle this
      patch :DATA
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f73dfdfe63a9d034ac0bfff95a25efe4144b6f82955335ef1d8e11db6d78cad0"
    sha256 cellar: :any,                 arm64_sonoma:  "686b56f4049b753532bab59ed5b36981f705d8689654b1670438774add89a6d0"
    sha256 cellar: :any,                 arm64_ventura: "4ec1abcb7d9a85fc28ceae28af1a1014d7de50e3aef60411d09922f6021762ee"
    sha256 cellar: :any,                 sonoma:        "7df9f38a3362c63f77a79bd668021e4fde8351d389768808a23599ea37c12662"
    sha256 cellar: :any,                 ventura:       "089a80a914b6798ddc2280b64f0a4db3bb9df588538b53b22b2e760080452ceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b968756c76097c32a5a47f8573bd330d16c2e8c792aa9c07cfc7d26f784339f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9242501e64de113097a77d7b3e5353ec15192e4261e25637f046a3aa392331"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg@7"
  depends_on "game-music-emu"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libopenmpt"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnutls"
    depends_on "mpg123"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  def install
    if build.stable?
      resource("asio.patch").stage { buildpath.install Dir["*"].first => "asio.patch" }
      Patch.create(:p1, File.read("asio.patch")).apply
    end

    # Pretend to be Nix to dynamically link ncurses on macOS.
    ENV["NIX_CC"] = ENV.cc

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["MUSIKCUBED_LOCKFILE_OVERRIDE"] = lockfile = testpath/"musikcubed.lock"
    system bin/"musikcubed", "--start"
    sleep 10
    assert_path_exists lockfile
    tries = 0
    begin
      system bin/"musikcubed", "--stop"
    rescue BuildError
      # Linux CI seems to take some more time to stop
      retry if OS.linux? && (tries += 1) < 3
      raise
    end
  end
end

__END__
--- a/a5a8a4ba6e21e09185ce10b5ecb48d6bb30f3d07.patch
+++ b/a5a8a4ba6e21e09185ce10b5ecb48d6bb30f3d07.patch
@@ -29,13 +29,6 @@ Subject: [PATCH] Update to asio 1.36.0
  create mode 100644 src/3rdparty/include/websocketpp/transport/debug/connection.hpp
  create mode 100644 src/3rdparty/include/websocketpp/transport/debug/endpoint.hpp
 
-diff --git a/src/3rdparty/asio b/src/3rdparty/asio
-index f693a3eb7fe72a5f19b975289afc4f437d373d9c..231cb29bab30f82712fcd54faaea42424cc6e710 160000
---- a/src/3rdparty/asio
-+++ b/src/3rdparty/asio
-@@ -1 +1 @@
--Subproject commit f693a3eb7fe72a5f19b975289afc4f437d373d9c
-+Subproject commit 231cb29bab30f82712fcd54faaea42424cc6e710
 diff --git a/src/3rdparty/include/websocketpp/roles/server_endpoint.hpp b/src/3rdparty/include/websocketpp/roles/server_endpoint.hpp
 index 9cc652f75ce1c31c597341e5ec2ad47ce17a40be..1967a4733e1a77045f8b5bce6cd0fad335c7a4a5 100644
 --- a/src/3rdparty/include/websocketpp/roles/server_endpoint.hpp
