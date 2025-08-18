class Lasso < Formula
  include Language::Python::Virtualenv

  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d11f5c5002eea8bf352df2eb6d3e903a25cf985c624d764d908646b7193d7787"
    sha256 cellar: :any,                 arm64_sonoma:   "bae175f8483fcb721716c04489109384cf80f7b1b3e2dfddfe2bbb785e0cbddf"
    sha256 cellar: :any,                 arm64_ventura:  "1d90d46ff6490946d1f8e156038fb83fe63c59f7bebab3b712ee6eeaf73175c9"
    sha256 cellar: :any,                 arm64_monterey: "9b7b4aaf4ebb484bc9965c44ec60b5688bf07160fd21009b3698c9906339ceca"
    sha256 cellar: :any,                 sonoma:         "1ae094adf28b557f503e6902eba7782fc3f06851f99af55bb719cd1ef5421acc"
    sha256 cellar: :any,                 ventura:        "c70b29501fec372898d179cc2b90a8778135b1b90679cedbc9d04967c23be6ca"
    sha256 cellar: :any,                 monterey:       "c502d05c3014a4bc43418345944c10ad4f5aa7e65743a83b374b51f8f44d2eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "06aec249f21d3077204ca46f10391df23570448ff47650cbeefd69455dad5a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9adf24a05cbf953ad5f3d3bca3f388eadb08480aaf9f100663504c2ea83ff025"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  resource "six" do
    on_linux do
      url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
      sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
    end
  end

  def install
    ENV["PYTHON"] = if OS.linux?
      venv = virtualenv_create(buildpath/"venv", "python3")
      venv.pip_install resources
      venv.root/"bin/python"
    else
      DevelopmentTools.locate("python3") || DevelopmentTools.locate("python")
    end

    system "./configure", "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    C
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
