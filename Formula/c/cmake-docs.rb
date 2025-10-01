class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.2.tar.gz"
  sha256 "643f04182b7ba323ab31f526f785134fb79cba3188a852206ef0473fee282a15"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f37832472cb873b81463754d19e79c4e54438f0664baaaf18c3e9b15608b5ed"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
