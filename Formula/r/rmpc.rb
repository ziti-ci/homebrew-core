class Rmpc < Formula
  desc "Terminal based Media Player Client with album art support"
  homepage "https://mierak.github.io/rmpc/"
  url "https://github.com/mierak/rmpc/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c0dca5f4be1222591a69b82e77d6fe42df259e6130ea7ea7dd6372515b5f4357"
  license "BSD-3-Clause"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/#!\[enable/, shell_output("#{bin}/rmpc config"))
  end
end
