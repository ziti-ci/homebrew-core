class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.105.tar.xz"
  sha256 "8655ce796ded4885921a1bf26992e970528ca86d7913d52b2a043bfcf72173fa"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bfec5a0ba022f746b7bf07a47616856a641bdc10a7c2fc63e436373efa6287f5"
    sha256 arm64_sequoia: "d795c478ea9cebd51a2dfaa98493be6132402d271e01fbd0e1881218d507616e"
    sha256 arm64_sonoma:  "a240259d5c42e30da73493db37fe85e04f3f4f9f027ba047ebb0e10db691dda4"
    sha256 sonoma:        "4d858d31970a642e413fae2bac4d169a361b45ddd3692062178f1700e58efe47"
    sha256 arm64_linux:   "fe85b05054f41287647a07354456fc3509257d95ac90c03aa0ef1d19f5fcb9d4"
    sha256 x86_64_linux:  "4ee7ea96b7faf9c9685e2d5db2955c0cfc56bd475219d8beb6b2b388a671a998"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "bc" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libedit"

  def install
    # Fix to ERROR: None of values ['gnu23'] are supported by the C compiler
    inreplace "meson.build", "c_std=gnu23", "c_std=gnu2x"

    system "meson", "setup", "build", "-Dlibedit=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
