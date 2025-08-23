class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.42-4421.tar.gz"
  sha256 "4e8549967b25cbdc247c27297ef8bfa84a27f291553849fd721680c675822ec5"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee4f7d945e4fbfc8cec8726e34e3918b4e7a81267afdd0858b61e8f54647b262"
    sha256 cellar: :any,                 arm64_sonoma:  "17617ea29564f33a42224532baa7afd97965b3db0e443487984bbd815bcf2d17"
    sha256 cellar: :any,                 arm64_ventura: "59bd03c16a5706bcea46ede1657d3f0ed93d5fb79c5cf174d6e9df6ab8de1c8b"
    sha256 cellar: :any,                 sonoma:        "90e74aa7639dfe8edd07b756779dfa568256650296692cfede27c9f16e689598"
    sha256 cellar: :any,                 ventura:       "56e41035244c0ee13294e38312b35929348e7ab758ef6e1f7ab5add72b2c247d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fecdddf81887acbd722d27c294c86d1ae6768347a01b5b80f70014a8a8d5016a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e886eb4452ddfafee2041a67e2233c7a435e344e0ab7e99aded78383eba32587"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
    end
    system "gmake", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "gmake", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end
