class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.10.tar.gz"
  sha256 "29f4b7c392b04c7b5f9191a4647ea222856f95d79a6756c52c0bd93c70bb94a8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "42e42212a6aedb74058a40d1e024f4658265bad65a2b7f4c6147030294f11b83"
    sha256 arm64_sequoia: "2a19768c1cadf90180bb77f1ac73b11bac2cdf3b1ee0cd52aaebd76dfb174623"
    sha256 arm64_sonoma:  "6be02a07209def77997223c4a884efb1537fb4d7d7afc829a689f74b155b7f3b"
    sha256 sonoma:        "aa028f80f340fb3978d2b36ae1cb3452e5e7cb89191b17621d5b16dc58e62b4d"
    sha256 arm64_linux:   "05123991f810037b1d3473df4175c6132911047e92ddf8ad5550386fcee3e479"
    sha256 x86_64_linux:  "46fafdbda46b3c395054b72a420c7df21277eb8d20b2eeeccc89e4b7b04e473c"
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
