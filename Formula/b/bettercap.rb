class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.2.tar.gz"
  sha256 "990fe894259b0129ad1e331d020b151f1494f850ef25be3e110e8ddc9525b79f"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bb7a6d6cd4d05376150aaf6f3e636748e6f7c25f55a7020414ce5d9ec9f2b28"
    sha256 cellar: :any,                 arm64_sonoma:  "ba4ebfe92ecc1c3dbe6f316d8caae94db58653b69748824ab7c4536392bcbbac"
    sha256 cellar: :any,                 arm64_ventura: "24a234febe71292390e60b28d5c9dd570003d26e01c439ecc724a600b22fab32"
    sha256 cellar: :any,                 sonoma:        "64d654c858082709adaeeb902a59ed81b581a3142dcfd7386c3f370144fb9595"
    sha256 cellar: :any,                 ventura:       "1820c1c01213158db3703d6e9bc9d7bb3ab3d4451da7de3daa18b90bd1cfe291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f88c29696e7607598f42b0a0fe8ef73ffe91812829666e0ee7cdb665a2ae4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "678b0e10c0ac69b43e12c5bb6e5e96663b1e30a1febed2e3a9d4efe1f9f0a443"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  resource "ui" do
    url "https://github.com/bettercap/ui.git",
        revision: "6e126c470e97542d724927ba975011244127dbb1"
  end

  def install
    (buildpath/"modules/ui/ui").install resource("ui")
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "Operation not permitted"
    else
      "Permission Denied"
    end
    assert_match expected, shell_output("#{bin}/bettercap 2>&1", 1)
  end
end
