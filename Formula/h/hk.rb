class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "050c063753b3de24ee8b6e0511e035c3be9ae94c0a267610c05a255c0fd742f5"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "791ee64b4770405dfb72488b2a7b5dfc5c2f56c847b155f89fa30cd8e6dee8de"
    sha256 cellar: :any,                 arm64_sonoma:  "ae336accfbdb56a0a32e602364eed6a78f20216fd8b6ed3e86a11b6b59138cb9"
    sha256 cellar: :any,                 arm64_ventura: "f9f2bcadc75a2341f74c21955aab3ee8ef31a723fb00600895616cfb6290a986"
    sha256 cellar: :any,                 sonoma:        "092e09c0f978716451cc42fb0f31d82ae22ab4cbff9abacdef683cd88e24974e"
    sha256 cellar: :any,                 ventura:       "fa4228b3912296472b3db5deb4685daeca723d0390c99b14684b57eb57dbb06d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e3b8e07a00098a13ebcc993175fe5f6ccbf4f7d308b3aa12fbc66083c92ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d409c802444013a4a2aaccc86de716e2b16d0d75146a08bb5fad2250d5c61fa8"
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
