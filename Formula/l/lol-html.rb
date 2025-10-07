class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "f0e42a25eca75468fe03afc5c0d029030db7d334d0b2d34ccaab2f8896a91a22"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6aa1f1dab27a8cbeb105125b718db6f3c71bb594b505c63f23896533e6699cd7"
    sha256 cellar: :any,                 arm64_sequoia: "89f0ca9ed3b49066d35ac9732e58302f58a6b889dd1121511fef7fcd33db5b2e"
    sha256 cellar: :any,                 arm64_sonoma:  "9b10e11a420527f0b662c7c700bc8c7735f043e1b2f9061bed195aa85447876f"
    sha256 cellar: :any,                 arm64_ventura: "010931f14b4c76172dab582e23a99f5cb409214326dab74957166ec1fdeb4905"
    sha256 cellar: :any,                 sonoma:        "1dc5325513a61a31c98dcd5904495315cdd2f67b37e9ac38b776a81fdb5334fb"
    sha256 cellar: :any,                 ventura:       "21bfafcc1f3038a257b4a0411c2cdfdba4e7655cbb2310c4b4dbd47ab3b70637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f9ce231da7b18226b2d2d8b6bc9eef8161c453261421d3f63c0a3e5bfe6db36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c45150bab75e53e4e1fb4ba839629377b7844c52d067f78240295ad776c338"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <lol_html.h>

      int main() {
        lol_html_str_t err = lol_html_take_last_error();
        if (err.data == NULL && err.len == 0) {
          return 0;
        }

        return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs lol-html").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
