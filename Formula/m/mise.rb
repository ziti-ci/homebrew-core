class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.8.12.tar.gz"
  sha256 "bbb8b4ff235a312d2941996c5141a6ff50aab3e3e458006d2a6855152246b48e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0990020813f68c44e0e6bb02096a9194d2fb9a745068a5159c93dfc2471fe9e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1efa6c967a0104ca0332203e262157541a6a4543e1859070d0fc033615141ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24e9d8b798ff39e6b7e38aace7743a70c2d327b06778e00b715ad8d9877b6c48"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fef3229de691b57a26ffaca7c066579a10b631320da73efa8f2f35a53a99d0"
    sha256 cellar: :any_skip_relocation, ventura:       "714463fbccb4770d99082432386d65d217818de311b0c67b47d8714d09b1fca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c47723797678ecadb73969c8f52bd61a5da81fbce4c4f04a2e01c151cbea2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c56ed71efcbfb54a698bc6cb5bb1c37cf93686c7c19b43bac0138b72c3a16c"
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
