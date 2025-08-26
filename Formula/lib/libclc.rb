class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.0/libclc-21.1.0.src.tar.xz"
  sha256 "1fa36516a5bd56fd2bd4e6d327a85b6ee226747a79a17b004fc1a09933376743"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f93f9e5c39eebc5962925a26707ca510af410bd7576ca3d2d442234a2bcd0a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f93f9e5c39eebc5962925a26707ca510af410bd7576ca3d2d442234a2bcd0a4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f93f9e5c39eebc5962925a26707ca510af410bd7576ca3d2d442234a2bcd0a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f93f9e5c39eebc5962925a26707ca510af410bd7576ca3d2d442234a2bcd0a4f"
    sha256 cellar: :any_skip_relocation, ventura:       "f93f9e5c39eebc5962925a26707ca510af410bd7576ca3d2d442234a2bcd0a4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f93f9e5c39eebc5962925a26707ca510af410bd7576ca3d2d442234a2bcd0a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1a0195d8e4ad1077d28a2e13d80548abbb31f8956c8bf9a55f3dc79c076629"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end
