class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.2.0",
      revision: "f6c7293a8c6199f9ccc07c7d650737fb5d788001"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

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
