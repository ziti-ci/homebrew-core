class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.8.20.tar.gz"
  sha256 "f92d22face0128612fe27039f80beae0cd30335240cb7be1aff22b429048f485"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252de8759bfe28869a9c28f87d1839c231818ab4fe4ba7cd8b799b8f5ba2f4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4bcc5cc0892677459332d7336916ccfde3102561056b5fdb471ade97dbf31ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d9aa2d63a7be93129df2b36c49255c7c7351c7d22470925706f4365e939bdee"
    sha256 cellar: :any_skip_relocation, sonoma:        "13997cd48c0ddc5892f0cdd78d8f461ab468bb20ded82e3c7e0c575e121f0653"
    sha256 cellar: :any_skip_relocation, ventura:       "68e7bb0f69f8ab03441e4ef7dd282b32ba2501b7a79a53471ecb1a033a798565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476592ad0ede0912ff6a08de25ffd5afea4c9292dbd37cc3d39e0262a06c9a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d6f955a077659c03b633ce1d4e36514e8683ed987b3125aaecaa742a63b812"
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
