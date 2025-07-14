class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.7.10.tar.gz"
  sha256 "bc86c543a313c5cef7a23c8887c751f7ec3e56eb5916523052ad71df3ba686ee"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b270a901d2ecef09de252a368f3dcc2ac788dbff9a61d551cc4d7b40374304c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "968b33bf79cefc3824fd5bd838f8fa6da4f725c64634fb6d80ceb87fe709eace"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9be89a4ce22d40735b9b8de025450891ab00610a7f9a3bbbc836b15a1b8ac1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f0ad53d6f12f5ef8f117351ab385b6f2c25689ceaa93a35b647e84757283c65"
    sha256 cellar: :any_skip_relocation, ventura:       "782f1a1b8a147386748fc0f49213ade54331b42d6884708859353b77cd40f0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdef0cddba36279c172fb1bd69e7e9fce32c5c150fae6b9bd139172c669bd56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151483b978482379e5f0de6dccf670523ce0e0802a5ba0f8d5241822a01cb607"
  end

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
