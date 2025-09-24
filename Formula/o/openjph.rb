class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.24.0.tar.gz"
  sha256 "d7fa60f70ed2555e5cf8bcc77a7e33ac323da3476997152a51bb608334850c66"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4940b78f3d9f1616ff9534c5ce3d43be997f17b4c57baa1c6c561729c9b3b43"
    sha256 cellar: :any,                 arm64_sequoia: "a6c7c9957bfcc028ea2e48b30f6bbfb23179e2277f9facbea83a64c5a7f46f6a"
    sha256 cellar: :any,                 arm64_sonoma:  "b8ce72ca20db7392431412b5f221a2e56847663239798ce3af1f81152c992943"
    sha256 cellar: :any,                 sonoma:        "22a8b4d261b5b74481afd02dc5d60bcd0b2e6a2798d8e2595ef6861736d5ce5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85f5540b1bcd10a1ad20a845112f1e9604dccfaf3e2fe2022babf5c0241accb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936577d9b53068ac638fe3a25e5e05e1e6ba63d3ebf36f4a25dfa50a44cd516b"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end
