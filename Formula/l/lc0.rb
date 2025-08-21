class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.32.0",
      revision: "b38ed00a25baed9554d2675ec376bd50dad18195"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25d5b0e4a549bbc2e1dae7af722c5aec25016ce421b160f4619121b22286c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f528105e9e803ce4fc4e710d3a94b02b192b0d055ec105cd460ca9c5ecaea1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aeb4b6042e63d1caba7f44e7a753b54032fe2c3a5b9d30b1c49db4149adc0dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "23318830a811ab5d1047779f6c3fe6bd9d1c2cc4e8ede7713c8027624b36a445"
    sha256 cellar: :any_skip_relocation, ventura:       "fdf20fa39a246862aa429134e633763fa585b0a9b23865fa82bbbddd29a96596"
    sha256                               arm64_linux:   "c4a48bea8d7085a67ff4bfea83e3536b0944bbf78f5deb997e7a37f51439797b"
    sha256                               x86_64_linux:  "4f996c61da081b7421b72a5b1a7c47e0d69ccc0f626185c1016b3df45aca48a4"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files
  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https://training.lczero.org/networks/?show_all=0
  resource "network" do
    url "https://training.lczero.org/get_network?sha=3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["eigen"].opt_include}/eigen3"

    args = ["-Dgtest=false", "-Dbindir=libexec"]

    if OS.mac?
      # Disable metal backend for older macOS
      # Ref https://github.com/LeelaChessZero/lc0/issues/1814
      args << "-Dmetal=disabled" if MacOS.version <= :big_sur
    else
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "BLAS vendor:",
      shell_output("#{bin}/lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Using Eigen",
      shell_output("#{bin}/lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
