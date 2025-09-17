class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/bodo-run/yek"
  url "https://github.com/bodo-run/yek/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a161b1cc194aa48ca4da82da2791b4cbd600d6757047c8dca93db21deaaadc02"
  license "MIT"
  head "https://github.com/bodo-run/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b529fb72f1886f0cb8d3389e83c106928a4610882bea0a9ed9cf314250188788"
    sha256 cellar: :any,                 arm64_sequoia: "32cffe04f3e36b2ec7c24c5360e24b19f6b0d6943a186bea3635d8c68e8aa1c5"
    sha256 cellar: :any,                 arm64_sonoma:  "5f5dfb7d1e600e30631216274b98f5865da26cb0eee80f2a94da92ecbb368ca7"
    sha256 cellar: :any,                 sonoma:        "047afc0314ea274fff68411585f5a4f30fcdb2296082f1437b1330f7512c3968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0070924547d72b33370622f2f29a2a5ba21f73dbb97f9c5a710a28a8a880c18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2130f371af1611af9990c5eb6ba27647ace236883509c3b42d4a49714e656d40"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yek --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        printf("%s\n", "Hello, world!");
        return EXIT_SUCCESS;
      }
    C
    expected_file = shell_output("#{bin}/yek --output-dir #{testpath}")
    assert_match ">>>> main.c", expected_file
  end
end
