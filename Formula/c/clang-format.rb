class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/llvm-21.1.1.src.tar.xz"
    sha256 "23336f9f2290f2317121a5995e298a4616041ba06cbb07cfd1220a21b48775fe"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/clang-21.1.1.src.tar.xz"
      sha256 "65a19a75440c6d0f92138d82432e7a201677fad5cecf39d3200eaa2f458c29e3"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/cmake-21.1.1.src.tar.xz"
      sha256 "9c0b9064b7d0f2a3004f1d034aadf84d2af4e5dca2135ebf697b0a1eb85ef769"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/third-party-21.1.1.src.tar.xz"
      sha256 "e9b7299b0b32aa827231ed35101a3b5ea37dd5a45719225cb2c08ac571791233"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fcc9691a9972a992000f04bc9ce4be823363a7e7aa6dba74ede56835f07f3c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8224109e24bb0d01dd323bcd448711717421ab7a3f73447f1b4970fa3d18ebcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bc008ee896cae2d8c98c8823ed4cd07eb814a6fc261a3b1b03f00a8c939f853"
    sha256 cellar: :any_skip_relocation, sonoma:        "415926ba1bc32e535c359f68412872c810a043d0ee903260794aded5d47aaa0a"
    sha256 cellar: :any_skip_relocation, ventura:       "62df61cd5905569cff75a6616ee2f1e28c6f4269da8104e4d2e08e1c298fbf3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09db98dababd38e37b9cf5ba962ecd85e10b832466b5444154a72bf5e33e1e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400e0bf0b6a94c2c1953ed878696dedd67266e3d22883cec3af05426b5ba31de"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char* args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
