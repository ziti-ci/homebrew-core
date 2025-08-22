class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://waveform.prototyping.bbc.co.uk"
  url "https://github.com/bbc/audiowaveform/archive/refs/tags/1.10.3.tar.gz"
  sha256 "191b7d46964de9080b6321411d79c6a2746c6da40bda283bb0d46cc7e718c90b"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gd"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "mad"

  def install
    cmake_args = %w[-DENABLE_TESTS=OFF]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"audiowaveform", "-i", test_fixtures("test.wav"), "-o", "test_file_stereo.png"
    assert_path_exists testpath/"test_file_stereo.png"
  end
end
