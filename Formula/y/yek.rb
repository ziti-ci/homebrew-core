class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/bodo-run/yek"
  url "https://github.com/bodo-run/yek/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "ecbdf29ba2955fc33c4e43b3177577a08b05435523b1849924ec10605d2632bf"
  license "MIT"
  head "https://github.com/bodo-run/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f86d50befdfe79bf33618b3437acb41cf10a237e9100fa892f0947e5c45b0c0c"
    sha256 cellar: :any,                 arm64_sequoia: "23fec4b96bb6a450981eb753f2cddb8b70fa3d4dc9190437dceec42a84f6209e"
    sha256 cellar: :any,                 arm64_sonoma:  "bb56f2104c411e32d9a881a0046be675b4a4335548e94809eefaec917b765f4b"
    sha256 cellar: :any,                 sonoma:        "1184ae8f09b9716035056878b57a3198e276b92b2a6fc8a397dd0c738d52e110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63dc60d4faa710abd1ae6a7dbc45980cfb3d3d0a984126909929eb8491e431a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c81a8a19c6dbfe39247be43f120cbcc6e409dc8056d65044d613bb0a5559c4a"
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
