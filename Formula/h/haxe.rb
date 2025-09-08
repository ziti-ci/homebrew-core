class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  # TODO: Remove `ctypes==0.22.0` pin when `luv >= 0.5.14` for https://github.com/aantron/luv/issues/159
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.3.7",
      revision: "e0b355c6be312c1b17382603f018cf52522ec651"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e8b9ac34567f3367a0d6e420c3a64782113cb4b279bdfe405c42e74086c45b8d"
    sha256 cellar: :any,                 arm64_sonoma:  "7b578bd443368559647f8f4b83b4f8836f57a5d753fb039dadfbcdbe7de79093"
    sha256 cellar: :any,                 arm64_ventura: "20d95b7e36e2332cb253d226ddd5d321376235aa505e2a0a5ae20bdf023b4a6f"
    sha256 cellar: :any,                 sonoma:        "bc78b84d45023ee30a3dc005043d89171b3bd3489a917670bff5d91aeb48c6bd"
    sha256 cellar: :any,                 ventura:       "23effcc0f7131aa4c4367a357b1f6f905bfaf214ee08ba83d15e57b211680a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f095dbf4adcdbc71e5a95b089f67c25d9955e4f1a2dc4f1e158ad63491a2ae0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b93448c64ffe1c9250e868fde52012b3cef2543b4954e7e24697a221c57b645"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "node" => :test
  end

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["ADD_REVISION"] = "1" if build.head?

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "pin", "add", "ctypes", "0.22.0"
    system "opam", "install", ".", "--deps-only", "--no-depexts"

    # Build requires targets to be built in specific order
    ENV.deparallelize { system "opam", "exec", "--", "make" }

    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
                              "INSTALL_LIB_DIR=#{lib}/haxe",
                              "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = HOMEBREW_PREFIX/"lib/haxe/std"

    system bin/"haxe", "-v", "Std"
    system bin/"haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system bin/"haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end
