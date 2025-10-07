class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "28f055df34531dec2f2bcb1c931b32f821a88770cded91c05626bf355981d41b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b77d43c5e2042b04cf4aa513ec63753c24760eadead1257a2f56d059d76f720b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ba393995589f0d275cef0e9164693ac5ca547b1a8c5abc3e70e6c8a649a845"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb5d44b4848164d04a960edf98a61002bef55ac93152dc12b10e08620243d6f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb8352f9b51cf905524181e89bf28c901f499a142cdea3029cf4143a3b6c75b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f82826f994b5b59bd9ffb2908a782575c2a82197b6e2f0d178ff2c3c05916e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5607cf9559c2634e731cdee0339bd5ff866e40cb3e01668b6bea3bee8a4972"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""

    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
