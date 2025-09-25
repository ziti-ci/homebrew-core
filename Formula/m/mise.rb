class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.19.tar.gz"
  sha256 "08e235f081feeb2ccdeebff45edee93f85a1eaad0333410c37d0016463215eaf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a41cf7674dbf7aa155eca030e031f4932e6975348f7af813eb1a7b727526331d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95d287d0e15cca97e6515b33cd7aa12f3c60d5193dcaa3957e33c9aa682b5948"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895b96c4de9c58c3a0d52b798ddc24e6640e72e64560ac7d3412130b39245df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "20a3d37ab2248eb613de6f86cb25c4dc5b6831d035d74ea8ee66f630cc5eb938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f40a70421977ebd686ba07d6da0de6ea1f959dec35bcbdb8248969082e58ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a595f480c9a2ce090f4b2a50a22b4c19a809e583ab7c251c658c6d2616164a5a"
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
