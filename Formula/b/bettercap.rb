class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.4.tar.gz"
  sha256 "384848630f594fadd48e80406f4cf8ceccfe3f32dd9182f7e18c20240e74a5fd"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55b777ca201ef9884e028535c78f4c37195da5497e56e540a2089658c4682aa8"
    sha256 cellar: :any,                 arm64_sonoma:  "e79632c8c6e322c1d4f5383051038f6975885dbc39927ef639e308fd85318f89"
    sha256 cellar: :any,                 arm64_ventura: "fd4c15398ccbb477d2c4f12efda3a8f7770d08082c33c5054d44da26ed5f8c06"
    sha256 cellar: :any,                 sonoma:        "f3ef52f667dd504ede4e2c32a446aa949542dbcbacb29868ea6af926a5183209"
    sha256 cellar: :any,                 ventura:       "1ed708df10f7dd2e446e46e8e8b341e2a2aae67cca5b4926a0e1de4ecb86e487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd0271efce6bddc15d291b1e3510acab9aa0b6697a2ae230537dbc5dde40475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2809e111f0c78ae90495b4e452046f47c509f68f2d64b2f73d097186512355fd"
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
