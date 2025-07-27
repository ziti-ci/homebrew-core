class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.1.0/SVT-AV1-v3.1.0.tar.bz2"
  sha256 "8231b63ea6c50bae46a019908786ebfa2696e5743487270538f3c25fddfa215a"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e93837b76e46e9cfff5d2826fdeb6312842353b899d3e851c81d943e3cb87b57"
    sha256 cellar: :any,                 arm64_sonoma:  "21b309a7920d93b2f017114dfb76c770406bd5238e8fdd74b68717f50f4b9b59"
    sha256 cellar: :any,                 arm64_ventura: "3c65e6a356f2f09e9c8c7f1e9ca6ed44668646c70e4385a7319c2f4a0a58b181"
    sha256 cellar: :any,                 sonoma:        "075d6d284e3c9ec2c83b0295e8a7de3a98f5e80cd20a8829ab5a8c05e72acd3b"
    sha256 cellar: :any,                 ventura:       "4e251d72c313bde400f5a8cacda21b165c28177ea7c3a16f0a56fbfb115f677b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cdfe2836145ff6d33e546172d80acb58ae823f12bd43dd11163f285c885d7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e47620efee4766014dbfe212857f627f5b04c0cd30c99f57e53c145dd553820"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    # Features are enabled based on compiler support, and then the appropriate
    # implementations are chosen at runtime.
    # See https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/Lib/Codec/common_dsp_rtcd.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_path_exists testpath/"output.ivf"
  end
end
