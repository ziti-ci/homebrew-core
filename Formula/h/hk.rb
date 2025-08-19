class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "e7cc42551ebb34c1009dbf6f69c1823157cff82568ce81a8733fb58f5ba45f06"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89388c18a210300dd707e3cd60282b285294340d1679884b7f2c19779eada465"
    sha256 cellar: :any,                 arm64_sonoma:  "66e6c7e0c7f707394acc851e4b43e142cabc1e3828b81e6979aca0cfc1239082"
    sha256 cellar: :any,                 arm64_ventura: "9cc51e4e36d9b5c21f1b8e83bcfa25a6fcf811a0333c86a69547000607f185cd"
    sha256 cellar: :any,                 sonoma:        "df7102fe5cbd1aa8ccbb7eed2d8b263a803ede2ce51b050d3c11f13a3f73db6d"
    sha256 cellar: :any,                 ventura:       "8d7b3fc7de1f01af098f9111513f6b60c25c4025d9b2b32cb3135992dd5f1164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62f2eb6c64db917c905033204a62f8dbb0177f823dcea9c2cf2f45eb19b90b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aefd6c6e7842f08c07ef48febdc2d9787688e40e6a3223b0f14f67ab183cf7c"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
