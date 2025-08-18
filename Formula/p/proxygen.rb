class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.08.11.00/proxygen-v2025.08.11.00.tar.gz"
  sha256 "adcb875fda718aa62fe47dc9b25c45c65632ccec583452f302624619a164e44f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "f3da126c26cbdcc23bf494e725fa2762ec55e051dbf973799f10c2d4eaf88658"
    sha256                               arm64_sonoma:  "5c9b413a911322b781d4c3678f7afef2d3ee4855f276ae94ea931097fdac2ebe"
    sha256                               arm64_ventura: "1153ae17ffd8123af0f755b3e2808048d1578b6190c04016f8faed8fef4ddf40"
    sha256 cellar: :any,                 sonoma:        "a241780f6ff7ead3e2114987768734dab40b97528807e5b472b3b6616c692656"
    sha256 cellar: :any,                 ventura:       "633c8e994de2a51a188e6208df20b08456797ec24026abbe89b0afc4ddfd9da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324b023efcd262dfd0b9f0527d7693b651233fe14a2877eebddb49f395aa6d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3442dee81c75d346b366906419ed098a14317e4991be6c1f479c710f7c1d0e0d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  # TODO: uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # FIXME: Build script is not compatible with gperf 3.2
  resource "gperf" do
    on_linux do
      url "https://ftpmirror.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
      mirror "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
      sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
    end
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/proxygen/pull/570
  patch do
    url "https://github.com/facebook/proxygen/commit/d69f521bc0c7201ced9326aabe7ba0ca590621bf.patch?full_index=1"
    sha256 "2b51cbce006750d70e6807bb186d4b06f9ec1c40f7109d0f0b8a8910581a39a3"
  end

  def install
    if OS.linux?
      resource("gperf").stage do
        system "./configure", *std_configure_args(prefix: buildpath/"gperf")
        system "make", "install"
        ENV.prepend_path "PATH", buildpath/"gperf/bin"
      end
    end

    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
