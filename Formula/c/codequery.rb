class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://ruben2020.github.io/codequery/"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "40781a7499adddddcb9b7ab2d1d840453aed08f91f5ebc7c339c2f13f63a9403"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e4fb0e6e4d1171bff615afc316580b9fa839da228349d9ceae861da9f184004"
    sha256 cellar: :any,                 arm64_ventura:  "7f2b375faf1d458989b42e8b03a4aa57599f54038e941752f50e18925ae4c43b"
    sha256 cellar: :any,                 arm64_monterey: "3f13a8eb9bfbd76b95c2a9f93759b9667574df9fd949e9332d268b3e3f699406"
    sha256 cellar: :any,                 sonoma:         "7d4ab5fa8902cc12ce5c8f72f808b8dab4399b3caa281ed04bc286ae0689e4fc"
    sha256 cellar: :any,                 ventura:        "9b959ddfdcb5bbfcf3ab2a09f07ef279e76db150230c8c8a5ef7a8ab7ad00c8c"
    sha256 cellar: :any,                 monterey:       "00a3a640de5c64f871865d155bba13485269d2d1c2ec4a68a13367ef789e6d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ad5e72b9b38a66604f6e1be788b94309e844276297037e402cfed743e25b80"
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    cp (pkgshare/"test").children, testpath

    system bin/"cqmakedb", "-s", "./codequery.db",
                           "-c", "./cscope.out",
                           "-t", "./tags",
                           "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
