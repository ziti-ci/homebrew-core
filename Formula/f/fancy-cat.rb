class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7191c8b6259f8124d2bef4c38ab0bcb7f13923dd84a6ec5cb5512f729765f5b5"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d975177d0f0fde37f9b79f62349384c5d6e3347160a94461297a8a763b99279a"
    sha256 cellar: :any,                 arm64_sequoia: "b299732956e601ea7d2a54f4f3f14824682b1a11b076af39fa3585c26c796248"
    sha256 cellar: :any,                 arm64_sonoma:  "b5a002414567b467d9b26f045094be7b083d2732ed0b14e94d854d4cc5aff241"
    sha256 cellar: :any,                 sonoma:        "dc6a0f9393de79b9f2ef197c091bb36bec3bb9d5130c787f9bb6567f31ec3e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fbdd2f88a238a1c58ee9e7658974fcddd28a1c8cb86657ecfbd2453099f1d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e79a56f2d66ae9ec3890331fb96ac285d53617fe5c6a6a39988e9c8f6b7a9a6"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
