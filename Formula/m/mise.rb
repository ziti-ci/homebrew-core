class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.9.tar.gz"
  sha256 "dc78eb8e1a03ab8c603a464d0b95b7cfa606a2421c739d4ccced89b668875b39"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8cec00b55ced2e80ef5359e509eb6af2fd5d793099a87a9313a5629cc61fcc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba4a0c60fe4fae406878822642c3b1db176a789fe9d4c02d0bf03aeb49e26e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a29278d8c4ec707f0469ae4609eea7cb6b5219a5f8e20cd00ecf1c67c619e3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5cc8825939e4ac4c73ca20476e72414f37cd9b0255001fc122263b93a2c8fed"
    sha256 cellar: :any_skip_relocation, ventura:       "39e6a41b43fb2b369b13dcba21ff966ebf84f13c66eee7a0e9a10c0fee50976d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b5be2be08c9f87bf1b01a91a48abe66c54179386efb6d321769773b16d0c972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2771586be00da296b79ab6f2c47f31204c582f2e3329b2aa6294068a24d3cab6"
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
