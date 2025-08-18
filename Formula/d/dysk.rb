class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7270ac504db20f05f704459e76533755e26af0300c267a2a7b5db397102be803"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "66a69344a33513bf01fec33960a6b88f6bee689671af08704efbb6481ec4f06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99f1b6df656fad0babd80cdeb986bc97043ae9636d2215fb79031d1c751607f8"
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
