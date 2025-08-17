class Qman < Formula
  desc "Modern man page viewer"
  homepage "https://github.com/plp13/qman"
  url "https://github.com/plp13/qman/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "785441bf11e99ff27869c08f0d36ce3f5c75db1b045b8712fe515059cf396780"
  license "BSD-2-Clause"

  depends_on "cogapp" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "groff"
  depends_on "ncurses"

  uses_from_macos "zlib"

  on_linux do
    depends_on "man-db" => :test
    depends_on "libbsd"
  end

  def install
    args = %W[
      -Dtests=disabled
      -Dbzip2=disabled
      -Dlzma=disabled
      -Dconfigdir=#{pkgetc}
    ]
    args += %w[-Dlibbsd=enabled] if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    systype = if OS.mac?
      "darwin"
    else
      "mandb"
    end
    inreplace pkgetc/"qman.conf", "[misc]", <<~EOS
      [misc]
      system_type=#{systype}
      groff_path=#{Formula["groff"].opt_bin}/groff
    EOS
  end

  test do
    match_str = "more modern manual page viewer"
    result = 0

    # Linux CI has no man-related support files
    opts = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      cp_r pkgetc, testpath/"qman"
      inreplace testpath/"qman/qman.conf", "[misc]", <<-EOS
        [misc]
        whatis_path=#{Formula["man-db"].opt_bin}/gwhatis
        apropos_path=#{Formula["man-db"].opt_bin}/gapropos
      EOS
      match_str = "This system has been minimized by removing packages and content"
      result = 2

      "-C #{testpath}/qman/qman.conf"
    end

    assert_match match_str, shell_output("#{bin}/qman #{opts} -T -l #{man1}/qman.1 2>&1", result)
  end
end
