class Paperjam < Formula
  desc "Program for transforming PDF files"
  homepage "https://mj.ucw.cz/sw/paperjam/"
  url "https://mj.ucw.cz/download/linux/paperjam-1.2.2.tar.gz"
  sha256 "a281912d00a935f490ce20873e87b82d5203bb6180326be1bec60184acab30fc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?paperjam[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "271b0d2b33c3f06f81fac58248a81a95eef0bcc36929230e2bad7b4d38ff34db"
    sha256 cellar: :any,                 arm64_sonoma:  "4df949ea647a2056ea7d7ab0ea2d298f45da5643ae92c25aaac80aad7e1301c7"
    sha256 cellar: :any,                 arm64_ventura: "1fd3b138f16296ab6107a43387eb5ea3b54e5dac2358b7b5b6e8bc6c7951f512"
    sha256 cellar: :any,                 sonoma:        "0d6af7df1e10f96f42f56cf222c6bfb35d384ed547f1b8b0e11352906a5af41c"
    sha256 cellar: :any,                 ventura:       "2fc406ca453bf24ade3b65111f80bb3fd0b1a761c316ee48540ed8341afc6d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a6fdbd3537bf7e095cf7ec80429789e08c0310083fd086ffdc9bf2956d37eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05712c9aeabd27e0ca3dd38ce377228044e31bccb7ee9bfb0a218b239f4838be"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libpaper"
  depends_on "qpdf"

  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDLIBS", "-liconv" if OS.mac?
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"paperjam", "modulo(2) { 1, 2: rotate(180) }", test_fixtures("test.pdf"), "output.pdf"
    assert_path_exists testpath/"output.pdf"
  end
end
