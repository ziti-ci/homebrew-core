class Fakesteak < Formula
  desc "ASCII Matrix-like steak demo"
  homepage "https://github.com/domsson/fakesteak"
  url "https://github.com/domsson/fakesteak/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "0f183a2727e84d2e128e3192d4cff3e180393c9c39b598fa1c4bfe8c70a4eb1a"
  license "CC0-1.0"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakesteak -V")
    assert_match "Failed to determine terminal size", shell_output("#{bin}/fakesteak -s 1 2>&1", 1)
  end
end
