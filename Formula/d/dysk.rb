class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "dbf81a3f22282c6e9b3205b00c6e58e54d85e5ed163b1384076f4eb4aa4f5e0f"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "28460b25dfcd3b4c91b57a3c3533efa2f4482ed4a021709f46e4e85566d66563"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d38cb8fb1e46360014f02bc86b96256257bd398c650a0a6fdcc68e434a870593"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
