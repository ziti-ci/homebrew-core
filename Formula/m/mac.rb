class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1161_SDK.zip"
  version "11.61"
  sha256 "0799c0a5e396b4350928b3cc1276096a04992835fecd2df979dacfc058323313"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc9c5859a78bf48de21e77244341b6895413234c5622a71cfda9bdcc44930c4"
    sha256 cellar: :any,                 arm64_sequoia: "3265536fbd458720eef85da34dfae0bda31617d56f6d235885f22661b8cd7e09"
    sha256 cellar: :any,                 arm64_sonoma:  "98075338f6a98c8db91c0ed748d1e06abdb33b44c3e8a8a63744db9018da549f"
    sha256 cellar: :any,                 sonoma:        "0c0c0527a294ff5d0e44938908eaa5d690ad256b56a08bc99fa9e3bb05b05944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6215134eeac747bcbed68f495b5f59e809cf5755cecdd2346859196090de30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a160b8a736d6177edb9d68c727e8ce6a6f169a530670c668e0e4ad0d3754584a"
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
