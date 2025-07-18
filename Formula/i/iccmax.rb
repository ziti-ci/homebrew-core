class Iccmax < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "dcb66f84016f6abe6033e71e2206e662b40e581dce9d208c9c7d60515f185dfe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c199d5cf09f566e818d2049fb093faf85d4db8d5523e1434291fa2c9472410b"
    sha256 cellar: :any,                 arm64_sonoma:  "1b74500262109e0e702597ed2342f488c4517b8f44800534e33c55c88b89bdaf"
    sha256 cellar: :any,                 arm64_ventura: "47bc9ddae076560477d5dcb2aba20a1f1ee6a1bfd7abf427bf70aec37c7b911d"
    sha256 cellar: :any,                 sonoma:        "7fb47953f25262626476ffa53e8b9a1062ac2f8dfd1a3c492c4cabb8159da326"
    sha256 cellar: :any,                 ventura:       "0c77e5b40278033497bdf99dd0f667a06b3e8ceb5ec47ee4c32802da98d8e930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e4b5ff79e1bec935b036745b9dd4fe399864472e88bfd3f7352130efa91b7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0923ecf885cebd5ad8dc4438ca1d594faa37f9139c1a2606494aca2f2a023a1b"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "nlohmann-json"
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
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
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
