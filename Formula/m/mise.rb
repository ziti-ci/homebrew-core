class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.7.20.tar.gz"
  sha256 "6f02eb16e77b9ef6a4fd344f2911fc49643d5e51bb132407b2108e973e1f360a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348147c37e754ee3cd2178f8617d513acff10552e6bd0b977afd2194f92c379e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "592705ab00af98ec7eab88ef698f1e12f6c23cb61b8939884a0ace981116c74f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bab52a45564ad5a9eb9fe5719fd67c0e22de0673c50e3d1ab520ef04c9cc8cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e349c43ef02c5c3524ec919da91edbc68a8919c898319bd60fce158b532f53"
    sha256 cellar: :any_skip_relocation, ventura:       "695a3d703b569a175ae5a76f7f84f8b87845cc64ee798d2e9549a79891dc1724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34d81681ddebbf9dceb34e7635c49e5b9da41f97121836bfcc3e596b851f4d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3335d55e77e03ad1839a2afff1f8430ada493d1a3d4f6dee71d366784d4b5b93"
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
