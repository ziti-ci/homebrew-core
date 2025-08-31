class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8143285f018aa84ad42a2e00ae3a1ee03ac394c7268dc8993c677cdfc9c4efb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8143285f018aa84ad42a2e00ae3a1ee03ac394c7268dc8993c677cdfc9c4efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8143285f018aa84ad42a2e00ae3a1ee03ac394c7268dc8993c677cdfc9c4efb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d54fa0749cc7a648f5724c1b4905eef9bf25be270d0923ab7d99d6830d35a86b"
    sha256 cellar: :any_skip_relocation, ventura:       "d54fa0749cc7a648f5724c1b4905eef9bf25be270d0923ab7d99d6830d35a86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0863f7848ea5aa0f24afe53ba523773bfbc732a6082249970c86d2b99d8eee6"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
