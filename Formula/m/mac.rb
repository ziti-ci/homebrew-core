class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1131_SDK.zip"
  version "11.31"
  sha256 "70e47891b8b0c364c9fc9e9e9d854d7d6034f50e4b47459065e6c900ba7332ef"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b59307bfa13c330f7b275b2fa0aacdf414514e51d46b4fac1617d9b6e0b72ba"
    sha256 cellar: :any,                 arm64_sonoma:  "f0f9156b873f18825b2d877c8e976cc87263c85eb1ca9e6d94c6ff126c2af08f"
    sha256 cellar: :any,                 arm64_ventura: "29e7ba8b4b601fa85200eb85916244bb2f5b2ea365b0578e971d7b0f85b5e36f"
    sha256 cellar: :any,                 sonoma:        "8454e0e17f9a62596dbe91d682c3c6d82f4daf0896cc12c98d1749e07a98590a"
    sha256 cellar: :any,                 ventura:       "4f78c3caf6c8eaa3d8d1025d2248677fd98025e56f56759ce572fc6cee63fa10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0ed52f6fbfe310b378270eefe1de750098cf731af8174930bb7f39a0d0986d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2772bf6b5944148c6e199c98bc740f56bb478cc54df1f5f3b139a089649dc5c5"
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
