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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb75c3de1404c099eafb6c072a056b8f39422618424fa0815d4b3cc0abb9d8a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8614a34b70c33e49aa034aa2d3b0d786159015eb8e4c5d47a58c4d146802a05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e81537234dc3623c4d257e5f91c603565bc7b18c9037088b3e612f9f7641c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c142b9b254c052221e500d0747448189dfbc49560bc2fc54b28a319e75e640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2be7a93d1bba909e749d26093278508a0979b72a086b3b75b263d1d6394a09ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25122f8262edf09055e540df843fe66b0de84af0c540cc0e99ac06ec1c214a76"
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
