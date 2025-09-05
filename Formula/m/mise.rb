class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.0.tar.gz"
  sha256 "f58d33c61dcfa06f2037916647279adeffb78519f06d1fd04e92573e1437045c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f12b4cc69cfd8f1c29cf50e87a348178ea59f8dfe4ea1fff548b1e716ff1d80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693f1851e586d7f98b340e4c497056f1a7876cf0857189606ceacb5bdf1da3ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d82c6068cfcbba97f7218c37b5bb84e46a36d64cb00029dc89e39ebc583dcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7298986e1e22509c1c787d31eaf10e6415a4ba1aae9b5d4918672fb178151b00"
    sha256 cellar: :any_skip_relocation, ventura:       "bbdf029bbc95ea8f1ece1632d3295d653b2a3c9d8889bb0d3f7244fe9a7d0aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb0064daa4a08b30c4a5a19e3d18599c325ff88d0dafb7a99b621572574cf734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c99d0cdf05e621edc6d8eb4f4927203d9c4a4b9e3071cfac143bb189b2e013"
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
