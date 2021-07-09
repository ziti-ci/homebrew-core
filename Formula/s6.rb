class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.10.0.3.tar.gz"
  sha256 "1d21373151704150df0e8ed199f097f6ee5d2befb9a68aca4f20f3862e5d8757"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "0b1fc08741d7984f569b1d9c00808c5dfb8e1ee065e97d8e0d8b55746fc6fe70"
    sha256 big_sur:       "47924b409c4d52519acf0b7d7757f689e78ce1cb272c297822597a59a37c4275"
    sha256 catalina:      "94906378d458e78a0909dc89bd5672ca8d33645b1b070be4974ac7ebe0f3aa15"
    sha256 mojave:        "e4024234358147987f7f6f599b73ddfd9bbe5e5fd414efcbc53577045a1dbb78"
    sha256 high_sierra:   "d6be4dd0697c711c1e35fe25e4f1365bcb1c198ab8fc8c3f3d7169b29ccb4372"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.10.0.3.tar.gz"
    sha256 "b780b0ae650dda0c3ec5f8975174998af2d24c2a2e2be669b1bab46e73b1464d"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.8.0.1.tar.gz"
    sha256 "a373f497d2335905d750e2f3be2ba47a028c11c4a7d5595dca9965c161e53aed"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", PATH: "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", PATH: "#{libexec}/execline:$PATH"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
