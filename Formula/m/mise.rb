class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.8.6.tar.gz"
  sha256 "4ff53ce3e2147875c344d05709a5abea0fa17c3d1348f45af133492ca7c302fd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa75863bd6a13208839ddcd8fdf1d4fa0dc6988ae4c1feb7d12b6ff007471bb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ec194de367fbdedf00aa57da3ec665caf20252eafee36689110ed1f38b31e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1df5d22b3f05f4b7d629cf1aabe474cf5b39e901d0238ffc3ce3cc48c2873708"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd59d21ebd2af3ef3f6057f71e5ba1282ab72c91d1c16831ca2aa9a042407c93"
    sha256 cellar: :any_skip_relocation, ventura:       "ac04e107805ee848f0d99bb1c86e6e5213400df61c9f57661dbcf22c4e31066f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c2aa385644bad3bf53d98809b939dca6bd4ad1a0329295e9c2cf669351a034f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d17313661db17756e4049a4bfe78664aac8dbdcfb5e3f0f57bccb0ff0f68ce"
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
