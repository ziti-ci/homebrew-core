class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "552e0530db508ca0c577070162c32a6e9512233f7306084580dfaef130cd01a1"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b935c8aaaa02b2c5ae4c070834db54b037ef266119ebd140804d2bb0c9159769"
    sha256 cellar: :any,                 arm64_sonoma:  "a556b2cb60c064f2bf543b504d7956a16c9876f15e406d29c52016320162aa1f"
    sha256 cellar: :any,                 arm64_ventura: "32afc4b31e7b1b5ebb36272117441701d79d8277803b969f87c07d0725e111bd"
    sha256 cellar: :any,                 sonoma:        "3d4b2d4d305cd57cc269e0dd9a8f0e010e5a288193cf91a4b3ee31b3ab3a0555"
    sha256 cellar: :any,                 ventura:       "57e023edf7c25eaa46855c5c358d7d41b0b6ef7cf00c9913a2933e5e13c2e565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab759bbe00e25a8d3e2667a8480c2a45ffb8391dc5e21dc29323a8ac2178ff8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c7b584922b9e8dec925d4d82b7023c948584c2c50c4c585ee3061cf2e3c13b"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  resource "clx" do
    url "https://github.com/jdx/clx/archive/refs/tags/v0.2.19.tar.gz"
    sha256 "b06f39d4f74fb93a4be89152ee87a3c04a25abb1b623466c6b817427a8502a73"
  end

  resource "ensembler" do
    url "https://github.com/jdx/ensembler/archive/refs/tags/v0.2.11.tar.gz"
    sha256 "967f98f6dfd19b19e0aa91808ea5b81902d3cd6da254d0fdf10ffbaa756e22bb"
  end

  resource "xx" do
    url "https://github.com/jdx/xx/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "cccdca5c03d0155d758650e4e039996e72e93cc1892c0f93597bb70f504d79f0"
  end

  def install
    %w[clx ensembler xx].each do |res|
      (buildpath/res).install resource(res)
    end

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

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
