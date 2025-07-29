class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "178b575244d967f4920a4642408dc4edf6de96948d37d7f06e5b78acee9c0b4e"
  license "MIT"
  revision 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "904ea26e7c245d368b8f2cec71d8eedb89de3d85dd267d0bf95daefa38f40ef4"
    sha256 cellar: :any,                 arm64_sonoma:  "7d844d13a832a4d73118be0717d3b236b948e1ee08eacced27bd1239a88bdbcf"
    sha256 cellar: :any,                 arm64_ventura: "f97b3d1c04da51710189cafcccbdd0ebaf3b97f5d2621386dcee5950e7b4e71d"
    sha256 cellar: :any,                 sonoma:        "dba648814f9b70843d7e47f54098d9ea9641a8082e1ba78e784f8a7a512fc543"
    sha256 cellar: :any,                 ventura:       "5f46b5d565c4075fd096a02de66b5aaf0bab272baa97b6169c2b821e81aaee6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed6cdc026445a5d57b08bacee08abbf2e929bb71fac6b76f0e6a472037bbea96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d26190d82f558a4deb06d20031c42c25fc701a9ffa81b707c0b7272b8b3a61ba"
  end

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      This formula now installs only the `tree-sitter` library (`libtree-sitter`).
      To install the CLI tool:
        brew install tree-sitter-cli
    EOS
  end

  test do
    (testpath/"test_program.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string successfully. But, we can verify
        // that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    C
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
