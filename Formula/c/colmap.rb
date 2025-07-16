class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.12.2.tar.gz"
  sha256 "d108ba931780c5617e327967316688c99393ba80f7012340e804158c5b790822"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "510e7cdf646bcf0d5e1cc9f331b39f7ac79db5c1cf291be9fcac4f91b965cb92"
    sha256 cellar: :any, arm64_sonoma:  "ad97f6405877d6d3945ce8408048fc3f4ede115754487675ab97bcd8ca607f02"
    sha256 cellar: :any, arm64_ventura: "cd0ead39beabfec473e1f104df5d463e2401293f3a7d9fbd357b386aa8556dce"
    sha256 cellar: :any, sonoma:        "761389df4376837d1c826107268eba4f7d883037f6cce90c4e23bd1b2a9c5d6f"
    sha256 cellar: :any, ventura:       "d77ceae392ff1508d9ae41258c9f5c8106559ca201910a9f3d09e411cf2e98c6"
    sha256               x86_64_linux:  "8e39dfd1b1ef25e26937953b02604a6a9db532ec301a0fd61956c84a0ef5eae8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "faiss"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "poselib"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
