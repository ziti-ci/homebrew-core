class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.0.2.tar.gz"
  sha256 "0519bd151a04ec19384e038bad55d6ddf6d8948e378c0cf62d29d5ef4ba8c672"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa6f9e147add30dbcf5c1c2eac4429c9661d520d906c7a23e5b2ba03e28ece23"
    sha256 cellar: :any,                 arm64_sonoma:  "9afe2ab82d578279265025b38aec68c738581683ee1e7808f5e493819af13643"
    sha256 cellar: :any,                 arm64_ventura: "35e5fb95d7f04ebeba88f0f30209982528e4d30099b2da74227d576914015cbf"
    sha256 cellar: :any,                 sonoma:        "05d47700e425a5ca1650e6b6776c5b6744d696daa5da090b7bd4b971c6707f7f"
    sha256 cellar: :any,                 ventura:       "c8e87477ea25f6e451745900e9df2951893c45c5f274515eaff3d02369481c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46c2fa840f5db7b9a98bc9f98759b11fbb494e05debbba1d53b307e3192374c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704c3989f5f58eb419f60e9978509f0b4dee9be62b6f30716c94a36f23ab45a1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DOAPV_APP_STATIC_BUILD=OFF",
           "-DCMAKE_INSTALL_RPATH=#{rpath}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath

    system bin/"oapv_app_enc", "-i", "RTn23_80x44p15_f15.yuv",
           "--input-csp", "2", "--width", "80", "--height", "44", "--fps", "15",
           "-o", "encoded.apv"
    assert_path_exists testpath/"encoded.apv"

    system bin/"oapv_app_dec", "-i", "encoded.apv", "-o", "decoded.y4m"
    assert_path_exists testpath/"decoded.y4m"
  end
end
