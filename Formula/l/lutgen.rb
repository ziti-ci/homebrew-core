class Lutgen < Formula
  desc "Blazingly fast interpolated LUT generator and applicator for color palettes"
  homepage "https://ozwaldorf.github.io/lutgen-rs/"
  url "https://github.com/ozwaldorf/lutgen-rs/archive/refs/tags/lutgen-v1.0.0.tar.gz"
  sha256 "6fb508e4c8ccd08157c2196114f2d3c8f513f521e1144979e47135fd852b338f"
  license "MIT"
  head "https://github.com/ozwaldorf/lutgen-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lutgen[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lutgen --version")

    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"lutgen", "apply", "--palette", "gruvbox-dark", "-o", "result.png", "test.png"
    assert_path_exists testpath/"result.png"
  end
end
