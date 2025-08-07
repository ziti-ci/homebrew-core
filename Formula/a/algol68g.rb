class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.0.tar.gz"
  sha256 "c95125268250f112167993514d73a1a761aa08b6e9dc42665ad9f598198ac8bc"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a6a870cec74af9dda8f847c408d06eef24fc2daaffcf8ea1687213cdcabbb468"
    sha256 arm64_sonoma:  "9200736201167178472b0f8d96730231865f81aa6bbc72509c975d1a0f44b229"
    sha256 arm64_ventura: "703c870ac8c4adbb2619d87d1cd59ce039adf1a301a41400994335c65cbc276c"
    sha256 sonoma:        "575162e4e4973bc213ee5d93bf9a1007b9233ed20cf3dde83053509f6178ddce"
    sha256 ventura:       "a7e0e50f75e0f95fb58d5572aeebc6981d6ce6c99cfbf45c1dbeb7085f19eebf"
    sha256 arm64_linux:   "2be08f5ebcec2749f85e1949d5a8a386e233c50319a7dc7827f3a5d34e85314c"
    sha256 x86_64_linux:  "eee10fc9c0c9e4c8dadf62fb903adbece604aa0709d528a40afa57e1cb5b4dab"
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
