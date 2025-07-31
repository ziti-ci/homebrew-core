class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.5.0",
      revision: "a161607e859e586e19925f179ec5e1e1ed6b2998"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "99828a6d0984a865e0d1797dedd5a65b5097a8c7cd7621e77950a6c4a7ae1a62"
    sha256 cellar: :any, arm64_sonoma:  "a23af3ccaa578660f374e1d1fa0a84f00fb5d8196043e60b534deb2de69935e5"
    sha256 cellar: :any, arm64_ventura: "d1b2778e04792c500c6c627eb966d4581f8266800a46402280e0b2c9dd60da7c"
    sha256 cellar: :any, sonoma:        "4aa566bb09e4835d0fa19d4a9f7bec69a88b3424a806c5ad3bbe56f5ce36e74f"
    sha256 cellar: :any, ventura:       "da26f8b5d42aaf4df2696e9f31d6d953cbf0937959b022dd526d372db6071da1"
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
