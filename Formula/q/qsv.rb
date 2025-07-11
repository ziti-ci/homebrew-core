class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/5.1.0.tar.gz"
  sha256 "9bed0898cce8de237a0a04f8d28947720dbb6d0b2919cf297007a1a57569dfd2"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/dathere/qsv.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9a267fd7703ce64040ed07cd967e05d7852f198fcdf0a8bb9d3cdf093f737d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "778b552af9b6c5896ed67e49eea45575e950635a661b3549f37627909b20f2a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea8ce4eefbbb7240e8203e4979fdb46e044d48c5bc0c12cd1b84bf8ad4d2983b"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d9dc6f10e54ccfd6fb74e26a3313404db8a8dbdbe8a5be5cdd3624a77d3e84"
    sha256 cellar: :any_skip_relocation, ventura:       "092dbe2634f6613266c88837868bde82f400753ef07d8402e027e41dc56ef9c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdfd821dc64fc067b2eef24b1a2ec49b25e74d53b5cec1c1dfbfef36ce07271f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9c71032e08aa04795c9a869e8d5333d8a3cdd94d4158a6b0d4d44eb412f655"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    # Use explicit CPU target instead of "native" to avoid brittle behavior
    # see discussion at https://github.com/briansmith/ring/discussions/2528#discussioncomment-13196576
    ENV["RUSTFLAGS"] = "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args, "--features", "apply,lens,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
    EOS
  end
end
