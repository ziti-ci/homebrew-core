class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "f9493050fdc5384c92d18f5445e73b3ebca80fe262c5af9e0c70044e56fd96de"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e223ebe631147003f803cfdc16e5a8d37ba8255d582e5ee1e1d617edff35bde"
    sha256 cellar: :any,                 arm64_sonoma:  "4fb06e4d4cb8932711a4323e90c357b19a732776ae9dd41d0c9e9b2789fc03a0"
    sha256 cellar: :any,                 arm64_ventura: "38af9e108dc3b84717a2d9005e9e96f9db5b5d755d0ebb0c29879834e5cb80c9"
    sha256 cellar: :any,                 sonoma:        "a8f00e8f0e5e6fc680c7a7819c3eb4b4a9489015cca17fae6c747348c96f91d4"
    sha256 cellar: :any,                 ventura:       "c939ed00f432f0e20ca516ffc012175a7b7b5fe204c68e8d5b189e5fbe1a2c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6f412b246dd58bdfba9c46a81a85c71821362d36caf88d3a9b39155729692ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6e74162a3642463cc8c6abcace48771171c1c74e80a1001ccaf8ed633d16f6"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.13"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.13")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
      -DCMAKE_CXX_STANDARD=20
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
