class Tkrzw < Formula
  desc "Set of implementations of DBM"
  homepage "https://dbmx.net/tkrzw/"
  url "https://dbmx.net/tkrzw/pkg/tkrzw-1.0.32.tar.gz"
  sha256 "d3404dfac6898632b69780c0f0994c5f6ba962191a61c9b0f4b53ba8bb27731c"
  license "Apache-2.0"

  livecheck do
    url "https://dbmx.net/tkrzw/pkg/"
    regex(/href=.*?tkrzw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  uses_from_macos "zlib"

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["zlib"].opt_lib}"
    end
    # Don't add -lstdc++ to tkrzw_build_util and tkrzw.pc
    ENV["ac_cv_lib_stdcpp_main"] = "no" if ENV.compiler == :clang

    system "./configure", "--enable-zlib", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "tkrzw_dbm_hash.h"
      int main(int argc, char** argv) {
        tkrzw::HashDBM dbm;
        dbm.Open("casket.tkh", true).OrDie();
        dbm.Set("hello", "world").OrDie();
        std::cout << dbm.GetSimple("hello") << std::endl;
        dbm.Close().OrDie();
        return 0;
      }
    CPP

    cflags = shell_output("#{bin}/tkrzw_build_util config -i").chomp.split
    ldflags = shell_output("#{bin}/tkrzw_build_util config -l").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *cflags, *ldflags
    assert_equal "world\n", shell_output("./test")
  end
end
