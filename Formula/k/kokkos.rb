class Kokkos < Formula
  desc "C++ Performance Portability Ecosystem for parallel execution and abstraction"
  homepage "https://kokkos.org"
  url "https://github.com/kokkos/kokkos/releases/download/4.6.02/kokkos-4.6.02.tar.gz"
  sha256 "baf1ebbe67abe2bbb8bb6aed81b4247d53ae98ab8475e516d9c87e87fa2422ce"
  license "Apache-2.0"
  head "https://github.com/kokkos/kokkos.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26666fe1198bcea56d20c8f858aa5ecf3e4dcc31766910e74c39bf25ade28e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eaccb23aaafea38ab764a05ef4054da8155a881e62e0ba19ae4f26d9c5702fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce8f2d69483623f162650c4586a5a6ccacfb3ecbc2f23864c0506aaa8569316a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0d37f57f6a027d359db8217801860e66b6f90662fd0e3483bf8c2b1122b1fa0"
    sha256 cellar: :any_skip_relocation, ventura:       "3c2927bd676c1481e81755ba450ca58258bc5716ebe931f67406e2df9b1bd6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbe74aa9490d0f03ee94eb016711405690a11ad69ed0d2080a37f7dbee70f4a"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -DKokkos_ENABLE_OPENMP=ON
      -DKokkos_ENABLE_TESTS=OFF
      -DKokkos_ENABLE_EXAMPLES=OFF
      -DKokkos_ENABLE_BENCHMARKS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove Homebrew shim references from installed files
    inreplace bin/"kokkos_launch_compiler", Superenv.shims_path, ""
    inreplace lib/"cmake/Kokkos/KokkosConfigCommon.cmake", Superenv.shims_path, ""
  end

  test do
    (testpath/"minimal.cpp").write <<~CPP
      #include <Kokkos_Core.hpp>
      int main() {
        Kokkos::initialize();
        Kokkos::finalize();
        return 0;
      }
    CPP

    # Platform-specific OpenMP linking flags
    extra_args = if OS.mac?
      %W[-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_include} -L#{Formula["libomp"].opt_lib} -lomp]
    else
      # Linux - use GCC's built-in OpenMP
      %w[-fopenmp]
    end

    system ENV.cxx, "minimal.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkokkoscore", *extra_args, "-o", "test"
    system "./test"
  end
end
