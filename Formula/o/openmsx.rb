class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://github.com/openMSX/openMSX/releases/download/RELEASE_20_0/openmsx-20.0.tar.gz"
    sha256 "4c645e5a063e00919fa04720d39f62fb8dcb6321276637b16b5788dea5cd1ebf"
    depends_on "tcl-tk@8"
  end

  livecheck do
    url :stable
    regex(/RELEASE[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3ba8300b8fdbcfffcdfb4012fb7df687230090655411d801afe57ca69e4cfb49"
    sha256 cellar: :any, arm64_sonoma:  "7c5e4756a68ed4a9dbdb7c1dfdc86ffb40e059f5198b3b15e6410c90eb0281b5"
    sha256 cellar: :any, arm64_ventura: "a69cc87e4cf618d3136d1bb7c83fd20d2b89968eab61daf52c75d48bd1c2636f"
    sha256 cellar: :any, sonoma:        "6f9d02fde2ef6c175c16a0f9c37b5a473ee89b3d9ed7c28f04093459ade4217b"
    sha256 cellar: :any, ventura:       "19303d260496f03b0ef43050132e2c4125715d91d5470333c93ef60568ab3767"
    sha256               arm64_linux:   "b05bb6887ddd5509c84fc6d88d540668eb6b133a9d12638df0a1b703917c2a2c"
    sha256               x86_64_linux:  "e0c3322fa46edfeb2f35a85ad63b62d183e166fcb6c16b8541b93186a46a010f"
  end

  head do
    url "https://github.com/openMSX/openMSX.git", branch: "master"
    depends_on "tcl-tk"
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "Requires C++20"
    end
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "platform == 'darwin'", "platform == 'linux'" if OS.linux?
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = Formula[build.head? ? "tcl-tk" : "tcl-tk@8"].opt_lib

    system "./configure"
    system "make", "CXX=#{ENV.cxx}", "LDFLAGS=#{ENV.ldflags}"

    if OS.mac?
      prefix.install Dir["derived/**/openMSX.app"]
      bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
    else
      system "make", "install"
    end
  end

  test do
    system bin/"openmsx", "-testconfig"
  end
end
