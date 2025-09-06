class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1142_SDK.zip"
  version "11.42"
  sha256 "250a6f7e8b02dfe34983397dd1a8679a87ba6eac4ddbc51234f63d3ee5cd6f2e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f574ee18f6aab02f30c3af161497a0f72289fa18de61b9c3cf5a92f5cdace49a"
    sha256 cellar: :any,                 arm64_sonoma:  "15d71d9b3c4e332cbbeba1624361c20e3b43e8dcf6473f8bf8a4e63a1af2261e"
    sha256 cellar: :any,                 arm64_ventura: "c46b4d7f1e1c098744c643b091fd1986373cdc27f4eb4a1143d246c55db3e12a"
    sha256 cellar: :any,                 sonoma:        "ad1c9eae991be3540de0642d2a651ba38e213aee1018d720b63b7a7b411e2859"
    sha256 cellar: :any,                 ventura:       "f59ac2e328caf822bde2e8ce04a3aa4f42085b2b365d1a597d653a0fcb2c4028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4acd231c646229856b59879309a38166f0e305ea4089a17e3f83db9b3d2a36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c204d9b5dd139d3e80093c9260d570998245f02a2391e56f4e29bb51f0c5f8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
