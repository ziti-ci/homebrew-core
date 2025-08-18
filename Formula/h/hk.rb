class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3ee19342b7f2149aa7fda36fdf14df9c5a5a02281de65c5c354325b80ee76776"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c51b03d0ee80a7d655e9cb2f8101eb891619a67105151da2ff518f784041c259"
    sha256 cellar: :any,                 arm64_sonoma:  "68d95b25b0e8c0fa858b902fe6efaa5a6173425c75d15acc7967313a73dbc8f7"
    sha256 cellar: :any,                 arm64_ventura: "de1bd6a1c87118ec0ee4f140c61c5d73ed52bb84378d7f4eb934aedcc1a4a9bb"
    sha256 cellar: :any,                 sonoma:        "6384ee690bbe9b220981da95d98e09f2ce6c1c7413e083cecd946cbd1581922f"
    sha256 cellar: :any,                 ventura:       "b634c76e07e41e13f38b393390f77a2e7e9abcab1b031ddca8a5f0d79bc2025a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcea7c3b10e89bf29722934bbdca1a801ed744839d726b4c066cf88e7c9a14a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6044cc734ed7f339f2a69ef02fc005ab358e8c099a6d43d94d6ac859c281ae25"
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
