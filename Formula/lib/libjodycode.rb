class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.0.1.tar.gz"
  sha256 "d0365b8b0762a79c3ff7913234099091c365fcae125436343224b4e39da85087"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2a821f7c73f07a4ea420aa4f414d879646b374b8c12c94ab383b7b0a3584ca1"
    sha256 cellar: :any,                 arm64_sonoma:  "e23b641ca33e5c082349f9ad05ac3c914c00526c4f56359784353284ac9d0bb7"
    sha256 cellar: :any,                 arm64_ventura: "1ff41309b7c181eb3e8649678b20e9d10695faca435d3307c9c20ddcee1c1f3c"
    sha256 cellar: :any,                 sonoma:        "17c072e6319675767fbf6024f20b9d0b01fca0ab70246ce412f9d8d4ee21dccf"
    sha256 cellar: :any,                 ventura:       "7ce39f917672aae1a349b6ddaf067c189e40100810986ded0410a8ff139308ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62cfb8f7e91afcb30c339aaa93cc154f734e951c29a54a2d5bd7ef444fc786b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce72b93d5b11ffa01bfe57b7bedbb63c33959b0e50a4f18a8c2fdcf2bc73266"
  end

  # These files used to be distributed as part of the jdupes formula
  link_overwrite "include/libjodycode.h", "share/man/man7/libjodycode.7", "lib/libjodycode.a"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libjodycode.h>

      int main() {
          int a = jc_strncaseeq("foo", "FOO", 3);
          int b = jc_strncaseeq("foo", "bar", 3);
          int c = jc_strneq("foo", "foo", 3);
          int d = jc_strneq("foo", "FOO", 3);
          printf("%d\\n%d\\n%d\\n%d", a, b, c, d);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljodycode", "-o", "test"
    assert_equal [0, 1, 0, 1], shell_output("./test").lines.map(&:to_i)
  end
end
