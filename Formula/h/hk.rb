class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "cb76844be5462bd756aca677907921a74a6b5fa34f81118160b7060d0b637b49"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93d03d9af11fc77f61b62d967a5c69f416976a7c612d23bf5be158800e4653fb"
    sha256 cellar: :any,                 arm64_sequoia: "4d25d9df2ce0a16a458ee5138cb9ff1b7f4b16554ef0097972d043fa771aa094"
    sha256 cellar: :any,                 arm64_sonoma:  "04def4feff8e2ba54dc655951641d32ecf7feda85e9fcc82a2747d22863b47e4"
    sha256 cellar: :any,                 sonoma:        "8aa2e0c23a680ae48a38d211577036fc992643b92646282e2f99f55f2fd6a9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5f6665a9da44617a0f478fd26cda37c810f9e7bc29605b0847a8cb0d5216ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa81e24b732a2a144263f493958f13048caee0b86a068e5746f9731fca6ea75"
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
    url "https://github.com/jdx/xx/archive/refs/tags/v2.1.3.tar.gz"
    sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
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
