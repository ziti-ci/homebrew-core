class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.17.0",
      revision: "3038b1aa7fab3aa5b7cf9530e31bd475410f89d2"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b7cffeb3f76a7620880d4c33fdd2b027957c1007628574f901a5abc4f443576"
    sha256 cellar: :any,                 arm64_sequoia: "b9ed1e9603efad183af80aab13673f7adc4557eb530490e4e3363cdd827a7b34"
    sha256 cellar: :any,                 arm64_sonoma:  "6f7f3392635194c1b3dda8772114f008388f55fef7f24c285739c3d92599e9c4"
    sha256 cellar: :any,                 sonoma:        "47946ac4ce85a0f32e3949f8c087a05ee37c0ad0a5a73c82a7c32ec6aec98242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140eea2a50b305593ccf87d01032e8f016df90809bdc95f9e0815c9c73402e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5131a1fbbdf1423ced53f26c67c76f0071290c08ac920ac64840fd406834c86"
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

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
