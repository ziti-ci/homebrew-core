class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "c14d3690ae218ff9c0b9871da0ea7dcf960eb19856ac25838a08bcdef4518570"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77f0d09342de06840cd59ad23a718813477b6017cda71174d76c0ce22fd70cbe"
    sha256 cellar: :any,                 arm64_sonoma:  "681f575769d65a1b4cb25552ec7fc0c8768c16fc92795d2b3ed6213bd07e0253"
    sha256 cellar: :any,                 arm64_ventura: "a02aeb68396516011a5e189ba46c7b0864e85ead9756779ac3dd0bf67e66a8cb"
    sha256 cellar: :any,                 sonoma:        "2fccb2d7b811575a738d95983af728bf41bd818d83998041e2a073d86c7a75f9"
    sha256 cellar: :any,                 ventura:       "276a41d98b6323bfac08153e2313c38dea8b2cac5e402eaadacddad38afcad0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6663fe1e2fcf0b95f5d8ef63e58cfcfb0fea9989c62d7eb6eaf2c3774621a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70a44e119c3e5602086845403c09d05069d1fffa4f51327e10d619c48c4b6e9"
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
