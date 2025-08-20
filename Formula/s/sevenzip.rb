class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2501-src.tar.xz"
  version "25.01"
  sha256 "ed087f83ee789c1ea5f39c464c55a5c9d4008deb0efe900814f2df262b82c36e"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc707e54e639a99f4bb1041dcdb981890b80711023d5d86122ad6f2fc75e9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3254fd85c69624613c4d2473bf0962cd0a6da95426db4103e7085a2eb6fb6523"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98b39cffa36a599b640eba229458461a1b9658b5a6ce1495ed9c06194ab7701d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1de5040b9b80f5711eda3f3dc75555c5b6a2eda7d20eea1a8d6ec56ab3583c62"
    sha256 cellar: :any_skip_relocation, ventura:       "93471f3ededabe6868538922a8268bef618ba992f2504826c37a391e3f7e3271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7503b0032b2724f7244f8fbf56be566bb31450973a120ea8a3380decf5b2c7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a9255bc26eba7518647e9ed69790864aaa3e0d16bb932856c318b468fab9f8"
  end

  def install
    mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
    mk_suffix, directory = if OS.mac?
      ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
    else
      ["gcc", "g"]
    end
    cd "CPP/7zip/Bundles/Alone2" do
      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
    cd "CPP/7zip/Bundles/Format7zF" do
      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"
      lib.install "b/#{directory}/7z.so"
      lib.install_symlink "7z.so" => shared_library("lib7z")
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read

    (testpath/"test7z.c").write <<~EOS
      #include <stdint.h>
      #include <stdio.h>
      #include <string.h>

      typedef int32_t HRESULT;
      #define S_OK ((HRESULT)0L)
      #define SUCCEEDED(hr) (((HRESULT)(hr)) >= 0)

      typedef uint16_t VARTYPE;
      #define VT_UI4 19

      typedef struct tagPROPVARIANT {
        VARTYPE vt;
        uint16_t wReserved1;
        uint16_t wReserved2;
        uint16_t wReserved3;
        union {
          uint32_t ulVal;
          int32_t  lVal;
          uint64_t uhVal;
          int64_t  hVal;
          int16_t  iVal;
          uint16_t uiVal;
          char     cVal;
          unsigned char bVal;
          int      intVal;
          unsigned int uintVal;
        };
      } PROPVARIANT;

      typedef int PROPID;

      HRESULT GetModuleProp(PROPID propID, PROPVARIANT *value);

      int main(void) {
        PROPVARIANT val;
        memset(&val, 0, sizeof(val));

        HRESULT hr = GetModuleProp(1, &val); // 1 = kVersion

        if (!SUCCEEDED(hr) || val.vt != VT_UI4) {
          printf("GetModuleProp failed\\n");
          return 1;
        }

        unsigned major = val.ulVal >> 16;
        unsigned minor = val.ulVal & 0xFFFF;

        printf("%02u.%02u", major, minor);
        return 0;
      }
    EOS

    system ENV.cc, "test7z.c", "-L#{lib}", "-l7z", "-o", "test7z"
    output = shell_output("./test7z").strip
    assert_equal version.to_s, output
  end
end
