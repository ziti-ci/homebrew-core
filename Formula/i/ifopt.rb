class Ifopt < Formula
  desc "Light-weight C++ Interface to Nonlinear Programming Solvers"
  homepage "https://wiki.ros.org/ifopt"
  url "https://github.com/ethz-adrl/ifopt/archive/refs/tags/2.1.4.tar.gz"
  sha256 "da38f91a282f3ed305db163954c37d999b6e95f5d2c913a63bae3fef9ffb3a37"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "ipopt"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ifopt_ipopt/test"
  end

  test do
    cp pkgshare/"test/ex_test_ipopt.cc", "test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    "-L#{lib}", "-lifopt_core", "-lifopt_ipopt"
    assert_match "Optimal Solution Found", shell_output("./test")
  end
end
