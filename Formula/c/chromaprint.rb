class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.6.0/chromaprint-1.6.0.tar.gz"
  sha256 "9d33482e56a1389a37a0d6742c376139fa43e3b8a63d29003222b93db2cb40da"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d074eaa951816006df71b92cf9b94151020a32f787b5ac0e60d7d8303e5cfd4a"
    sha256 cellar: :any,                 arm64_sonoma:  "85ad4051988d6609b4ad6a52da3bb0237698ec177562c91bdbe2c2567fdc3eb5"
    sha256 cellar: :any,                 arm64_ventura: "045e4296445d7df2b6ca92c7f38be54e6800b15b8f9f73f5096faa46cc80af65"
    sha256 cellar: :any,                 sonoma:        "ed813b567bc41715b232e3f6d0c60ceb8c14c578de63d5b0ab237f3a8cb6885e"
    sha256 cellar: :any,                 ventura:       "e741aaa28a560fd83e13f4d5af424b7b8b037dace190e7c20a752ebe866f19db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f11ec9c1500c4454e72b8e593cada9e2d45c5a7c83df7c45563cbc28440abd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8637d14ed163ba4bfcbabb76f53c33046945d33b3159c1d0e563369688a68902"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
