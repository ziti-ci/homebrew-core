class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.5.0",
      revision: "a161607e859e586e19925f179ec5e1e1ed6b2998"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9a6e63050015f633626233fe99d15a3e1d003bb712c06c4bf584ca25529544c5"
    sha256 cellar: :any, arm64_sonoma:  "5ef45bb85f2c242a99de70fb4ce485cc2c3425bbb0bf019cf4337a062c454610"
    sha256 cellar: :any, arm64_ventura: "258d6dcfdef799a2e01501b23e3e6122e0784f3288e438f882446e02adbd1ebc"
    sha256 cellar: :any, sonoma:        "4733d0e7f2584bb3389d5690e985c7dd6ede8aeeb0f20cdce01946b9c82a9069"
    sha256 cellar: :any, ventura:       "f018330cd63af85e5351cf2b100f84048b91f60b6d59601bb7f48cd6face0745"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"media-control", "get"
  end
end
