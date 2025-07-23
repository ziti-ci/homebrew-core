class Libcaption < Formula
  desc "Free open-source CEA608 / CEA708 closed-caption encoder/decoder"
  homepage "https://github.com/szatmary/libcaption"
  url "https://github.com/szatmary/libcaption/archive/refs/tags/v0.8.tar.gz"
  sha256 "8567765a457de43a6e834502cf42fd0622901428d9820c73495df275e01cb904"
  license "MIT"
  head "https://github.com/szatmary/libcaption.git", branch: "develop"

  depends_on "cmake" => :build

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXAMPLES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <caption/cea708.h>
      int main(void) {
        caption_frame_t ccframe;
        caption_frame_init(&ccframe);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcaption", "-o", "test"
    system "./test"
  end
end
