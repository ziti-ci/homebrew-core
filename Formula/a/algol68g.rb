class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.7.tar.gz"
  sha256 "f87844090cc5c141b4f5cb20b60b622068f31826f241e3788b2139b2bb1536b9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "24c809c1593a48f8c5bcd7c5743308292646b31c8563c691edb7c6e1b3334c65"
    sha256 arm64_sequoia: "4df35e8627c5603e57b8d3587129bc45481109b51a8898f9fecadb7aef49deea"
    sha256 arm64_sonoma:  "a59c55fcef8a65fa4a549b9b6f6ebf32135ade862b2e00854a4a9946c21881ff"
    sha256 sonoma:        "0736ff426eb1169983007de98aee9d0f73c31ab23e1046057bee32d5fbbabd3c"
    sha256 arm64_linux:   "0e906e8ad1ca4da7a81ba31a89e234a26a4a7ea63f9430bb30f3f0d7edae34d1"
    sha256 x86_64_linux:  "5618e97937a96f3595a86cd9e0bf960b3048610338239d447807d849938377b1"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
