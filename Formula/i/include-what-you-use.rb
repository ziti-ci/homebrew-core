class IncludeWhatYouUse < Formula
  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.25.src.tar.gz"
  sha256 "be81f9d5498881462465060ddc28b587c01254255c706d397d1a494d69eb5efd"
  license "NCSA"
  revision 1
  head "https://github.com/include-what-you-use/include-what-you-use.git", branch: "master"

  # This omits the 3.3, 3.4, and 3.5 versions, which come from the older
  # version scheme like `Clang+LLVM 3.5` (25 November 2014). The current
  # versions are like: `include-what-you-use 0.15 (aka Clang+LLVM 11)`
  # (21 November 2020).
  livecheck do
    url "https://include-what-you-use.org/downloads/"
    regex(/href=.*?include-what-you-use[._-]v?((?!3\.[345])\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "10a8ad73f9ff5ec579d6a85632d53b211365f8cd63b66e07185ce7f79cced1f5"
    sha256 arm64_sequoia: "5cee946e76fcfc0c7e548bf6c75e19dd19cc9f5b53ba2abb49b84b497d31e93c"
    sha256 arm64_sonoma:  "961a8e076d193d1023a186eb27cee0f0780d708f8671e14085105f8421506ec2"
    sha256 sonoma:        "95746df4c95222659e3ad8cd70884edbc2ab73e07f3a7f8feefa90d9dec8df72"
    sha256 arm64_linux:   "03d4580685dcfa37e09e6c826fe0550d763da0f3ed588f316e8d3ec83c67661f"
    sha256 x86_64_linux:  "8087d239e4bf1081bf8dd0c789218bef524fcb867577a0c805218af9a28b8f55"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
  end

  def install
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.sub! llvm.prefix.realpath, llvm.opt_prefix

    args = %W[
      -DIWYU_RESOURCE_RELATIVE_TO=iwyu
      -DIWYU_RESOURCE_DIR=#{Pathname(resource_dir).relative_path_from(bin)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"direct.h").write <<~C
      #include <stddef.h>
      size_t function() { return (size_t)0; }
    C
    (testpath/"indirect.h").write <<~C
      #include "direct.h"
    C
    (testpath/"main.c").write <<~C
      #include "indirect.h"
      int main() {
        return (int)function();
      }
    C
    expected_output = <<~EOS
      main.c should add these lines:
      #include "direct.h"  // for function

      main.c should remove these lines:
      - #include "indirect.h"  // lines 1-1

      The full include-list for main.c:
      #include "direct.h"  // for function
      ---
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.c 2>&1")

    mapping_file = "#{llvm.opt_include}/c++/v1/libcxx.imp"
    (testpath/"main.cc").write <<~CPP
      #include <iostream>
      int main() {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    expected_output = <<~EOS
      (main.cc has correct #includes/fwd-decls)
    EOS
    assert_match expected_output,
      shell_output("#{bin}/include-what-you-use main.cc -Xiwyu --mapping_file=#{mapping_file} 2>&1")
  end
end
