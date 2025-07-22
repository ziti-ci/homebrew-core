class Iccmax < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "dcb66f84016f6abe6033e71e2206e662b40e581dce9d208c9c7d60515f185dfe"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2c2abaa5454315b73d20938ebc2adf6559fdfa07b0fc37b185e1dc0625c5850"
    sha256 cellar: :any,                 arm64_sonoma:  "acbf2b5e38b5c9dd8fd9b036587722debdab74b26642d3d29b924d3fb694f364"
    sha256 cellar: :any,                 arm64_ventura: "a8bd2bd5f0567f58b99696cb53e049f8e59f42c8d10afce54b5dfb3f4b824672"
    sha256 cellar: :any,                 sonoma:        "972543a7e586fa2c0fbe2198b0443f0dec6afdf814823d150f1685eb77ed6cc9"
    sha256 cellar: :any,                 ventura:       "5854e3df89553f5605c391f99312809ed0e2897c746c9ab086f61b1355679f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46b9a7e1e2991ba3bf8f4e14e1e575c75b9e84273148a98c5e61d617bdaf26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dc874e26d747908e2190ea44491861d8018e694e662599fa6d95e18647a3937"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  # Build fails on Ubuntu
  # https://github.com/InternationalColorConsortium/DemoIccMAX/pull/145
  patch do
    url "https://github.com/InternationalColorConsortium/DemoIccMAX/commit/965e14fb0c00dd4638dac6056cce84bab9821b57.patch?full_index=1"
    sha256 "e40a632236e2b3da5df9b2313fee3d79eed601b9f91a81158a67577e0a9d397c"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_TOOLS=ON
      -DENABLE_SHARED_LIBS=ON
      -DENABLE_INSTALL_RIM=ON
      -DENABLE_ICCXML=ON
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
