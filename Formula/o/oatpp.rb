class Oatpp < Formula
  desc "Light and powerful C++ web framework"
  homepage "https://oatpp.io/"
  url "https://github.com/oatpp/oatpp/archive/refs/tags/1.3.1.tar.gz"
  sha256 "9dd31f005ab0b3e8895a478d750d7dbce99e42750a147a3c42a9daecbddedd64"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/oatpp-#{version}" if OS.linux?

    # Remove in the next release.
    # See: https://github.com/oatpp/oatpp/issues/988#issuecomment-2525575710
    inreplace "src/oatpp/core/base/Environment.hpp", "1.3.0", version.to_s

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOATPP_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <oatpp/web/server/HttpConnectionHandler.hpp>

      int main() {
        oatpp::base::Environment::init();
        return 0;
      }
    CPP
    flags = %W[-I#{include}/oatpp-#{version}/oatpp -L#{lib}/oatpp-#{version} -loatpp]
    flags << "-Wl,-rpath,#{lib}/oatpp-#{version}" if OS.linux?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
