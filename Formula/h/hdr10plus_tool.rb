class Hdr10plusTool < Formula
  desc "CLI utility to work with HDR10+ in HEVC files"
  homepage "https://github.com/quietvoid/hdr10plus_tool"
  url "https://github.com/quietvoid/hdr10plus_tool/archive/refs/tags/1.7.1.tar.gz"
  sha256 "39a6b63f83c8433e6e2ea1a4b54a3de6dbf24fff64b69566a99e6328f4f1d2e2"
  license "MIT"
  head "https://github.com/quietvoid/hdr10plus_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "assets"
  end

  test do
    output = shell_output("#{bin}/hdr10plus_tool inject #{pkgshare}/assets/hevc_tests/single-frame.hevc \
     --json #{pkgshare}/assets/hevc_tests/single-frame-metadata.json --output #{testpath}/injected_output.hevc")
    assert_match <<~EOS, output
      Parsing JSON file...
      Processing input video for frame order info...

      Warning: Input file already has HDR10+ SEIs, they will be replaced.
      Rewriting file with interleaved HDR10+ SEI NALs..
    EOS

    assert_path_exists testpath/"injected_output.hevc"
    assert_match "hdr10plus_tool #{version}", shell_output("#{bin}/hdr10plus_tool --version")
  end
end
