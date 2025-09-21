class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.5.tar.gz"
  sha256 "708292a583bb5072a8dbb14e408c2a1f61de9b8c9786d4e53b3e69bef5dad8c5"
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
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "26a255dcf4514ba323fd8432e0707d41a78957663cd9dae29d9721643ff4ce6e"
    sha256 cellar: :any,                 arm64_sequoia: "9db1d89d137c22936f096852017272d7ba739ccda6b75771e983be8b9392ab7a"
    sha256 cellar: :any,                 arm64_sonoma:  "69618b6cb44fed6f13814c8d7ef559dbd4f14bfd268952d58554a85d6baa315c"
    sha256 cellar: :any,                 arm64_ventura: "a6f22f38cc129c056f1aecec46a00d6aac5a392f4707826c67872bccabf8fc12"
    sha256 cellar: :any,                 sonoma:        "ebb47ab602bff2a08b8f610f862cb81df7252c6b3e1d66bf7a374b06edeaa8f6"
    sha256 cellar: :any,                 ventura:       "1a4c4aef8caa5bfc661831b17b1bf84d6695dd4f686c48ef4b6bcd629fa92589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15eeed9a2b54c2822d34a1f951ccc7f0a06da22c4c6731f836ab8105d3a6609e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186e8821eb5685fe54c2419c8cdcbf018460b3e60fe434ea6b53392b78e081bb"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
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
