class Iccmax < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.50.tar.gz"
  sha256 "f48fc2e3f4cc80f9c73df27bf48fca3de7d0a81266d7084df544941e61b37eb2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c65b4162c33709671fc0554926edf05d0ab5f0a4f37f9336d36e1f8fb7e237b9"
    sha256 cellar: :any,                 arm64_sonoma:  "2488ed5d87bbe84c802ba1803ae383c4d2ba6c793c0e3146a4d50c7e0aaa2c95"
    sha256 cellar: :any,                 arm64_ventura: "725fa427b1a4106eadb49acb96e112249e00dcd737a72e9430a116bde3adbba4"
    sha256 cellar: :any,                 sonoma:        "d1b0708ef55cbc7ec7a0bc39f87fb98417489fb0e59fbf34f63d836067fdb79c"
    sha256 cellar: :any,                 ventura:       "2b5aef1ad26aecc5fddf8f097fccf3fb1dedfc72bf5061a577a1720ebe5953ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2df8f147a9e2ed559a38c26cd1030e90982eb5fbf2048eeaac73d7d0937476d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef04980d03bed8eb5e7cce0480045d252efdcab85167368e75a4090a7274854"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

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
