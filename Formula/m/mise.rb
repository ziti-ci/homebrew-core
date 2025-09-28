class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.22.tar.gz"
  sha256 "a7885842653740cefe1abe869ddd49431231edaa1781ab5500e4cdef1769ad62"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad2dce93594aa3e35cb683a3977bb7b5ef181fbe84b8b1cb6155e50688772375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440cf9f0de3566d34110f4f63a6e7e3ac42276e9b8fbf552fd04b3bb101ad70f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a250cbb1b6d97bf395b081a7445707e4905fef47539bf7c1124d67b15fe6a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e9bd2998a11508ff01b68f0bc0d0a56e0ed7985dec67334b3f72d48ad9edb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53e1463e0f7a800a931738e6f5e4bc8e9ef242df339a4f342d64af777a492a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5ca9a5f388aa3ad95051f935d8c8ef4340229f0ce976d0377d48528e820ff0"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
