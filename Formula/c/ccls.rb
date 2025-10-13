class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20250815.tar.gz"
  sha256 "179eff95569faca76a1cdbd0d8f773c2cbbafa90e0fcce3d67a8a680066dce7a"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "bab741b9cdf3a65b32a9ded56977041854ea84233156e2a2cc6844d368c4fd46"
    sha256                               arm64_sequoia: "e9e2dfa3d50fed8794c77ca54c01ab922d40fed4d9e43b7374c1b9982fb1265f"
    sha256                               arm64_sonoma:  "9a6fb61ff9eee5a3122dfcccdc7d64b0fc63d720e79a4a7c5d60824c0acf7459"
    sha256                               arm64_ventura: "b12c07bff01f2db44152df2553711dd86848351f0f0d16b372289c90908cc592"
    sha256                               sonoma:        "b6d124927fb776640e9528947b6e52ec816e1f3ec7229dd2cbb647e274c32ab2"
    sha256                               ventura:       "20517554c04b283944ae28892e0b88139029873a45c45b19895bf4488d4878b0"
    sha256                               arm64_linux:   "773f2ac0a01f92f7473ddf0fd932d3b8be93efa1c39f261bb51a9cce64eccd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81e657e1923108992eb11bfe532fbc0e6753066924fd7906cc6b713b930e3a3"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! llvm.prefix.realpath, llvm.opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCLANG_RESOURCE_DIR=#{resource_dir}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
