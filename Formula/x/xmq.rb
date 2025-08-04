class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/4.0.0.tar.gz"
  sha256 "9c0654ed865a38ed57c73f159e8cba2757a0e8b42bbb781967be35469ae1f787"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d7da8d0ceb2639bc2ac307f045d8647080af15c81125f30a811c1ee90455ad2"
    sha256 cellar: :any,                 arm64_sonoma:  "72150d9356fc5173eed941e0517624564b764ba54379181a198ee1e28a43ffa4"
    sha256 cellar: :any,                 arm64_ventura: "7acebce89ff42528c5b3d8353a6162d34902a3c56d0e82cecaa86bdf8e96db71"
    sha256 cellar: :any,                 sonoma:        "5035028909fc2705baa474d6816dcf781bc8581512f86eade88caa670dd267b4"
    sha256 cellar: :any,                 ventura:       "edfdc4e650ca9d7b83425fbbcf60e027bab6f70897cb1fce7913abfb7186e867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f6ad29b2af0989d72d0eb5086839e9192107c8c3650998e104f12038e99eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00eb32cfcaaadf3cefb1336cbe140dc5ed22de1ea28be36ed44b271e407dc5dd"
  end

  head do
    url "https://github.com/libxmq/xmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <root>
      <child>Hello Homebrew!</child>
      </root>
    XML
    output = shell_output("#{bin}/xmq test.xml select //child")
    assert_match "Hello Homebrew!", output
  end
end
