class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://github.com/tlwg/libdatrie"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.13/libdatrie-0.2.13.tar.xz"
  sha256 "12231bb2be2581a7f0fb9904092d24b0ed2a271a16835071ed97bed65267f4be"
  license "LGPL-2.1-or-later"

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--enable-shared", *std_configure_args
    system "make"
    system "make", "install-exec"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trietool --version", 1)
    assert_match "Cannot open alphabet map file ./list.abm", shell_output("#{bin}/trietool list 2>&1", 1)

    (testpath/"test.abm").write <<~EOF
      [0x0061,0x007a]
    EOF
    (testpath/"test.txt").write <<~TEXT
      foo\t1
      bar\t1
    TEXT
    system "#{bin}/trietool", "test", "add-list", "test.txt"

    (testpath/"test.c").write <<~C
      #include <datrie/trie.h>
      #include <stdio.h>
      int main() {
        Trie *trie = trie_new_from_file("test.tri");
        if (trie == NULL) {
          return 1;
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldatrie", "-o", "test"
    system "./test"
  end
end
