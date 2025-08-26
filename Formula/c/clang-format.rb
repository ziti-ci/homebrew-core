class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/llvm-21.1.0.src.tar.xz"
    sha256 "0582ee18cb6e93f4e370cb4aa1e79465ba1100408053e1ff8294cef7fb230bd8"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/clang-21.1.0.src.tar.xz"
      sha256 "4c8d148d4c5931c65116d1a5fdebd9d9579c3d135f36551b1cad53e220986cb2"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/cmake-21.1.0.src.tar.xz"
      sha256 "528347c84c3571d9d387b825ef8b07c7ad93e9437243c32173838439c3b6028f"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/third-party-21.1.0.src.tar.xz"
      sha256 "60b3d8c2d1d8d43a705f467299144d232b8061a10541eaa3b0d6eaa2049a462f"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "058c443eba958c496f9f733ddf2efd86c5c6fd49d0e35002fe20870006b54b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d36b733427bb6c45e4377ace8f2c58e7ff1f60e9f57566b05361222e2f9239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e40f120fe0cb6d58a5f7a31bf40a5fb058c881ad6e65b72b94f9f87635938115"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e6c1d4c63c6bb3ecbf3731e165d6b90cf8876e89dd66eafff6523829a75c576"
    sha256 cellar: :any_skip_relocation, ventura:       "394297f330c399210e3d414b044adf257f5ad12a1a261a175d75a0dc0c1719c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20bdcb909e97b7d9b458bafa814ada78ecc01b4e1931df41843662f4d7c0d365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d9392c69984beb0a93420c98a2d5b4c8f3e7bdb77744e50ed68c6ea527e502"
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
