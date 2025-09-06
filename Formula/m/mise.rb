class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.4.tar.gz"
  sha256 "406b28194ed914d31a7851c32303ff20a7126a691231beab68edf590df8d7075"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe2c215eaa19ea35ae9b14ea55a99655bbd7895e2ccd2fa43f80aeeb0b60dfe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d983d521aba94521c00a4e19885336baf57e5b390de2a0a5607351a36f7e6e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1815b61f29ab90ca6c54230602f3d5bc38209ddb76247a5a40fcde1b0a6bdb9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c163f85b86e6c5b39556cf30c66d3a884dbe177cc1ee7139bc44745025e04674"
    sha256 cellar: :any_skip_relocation, ventura:       "2e0b98e411cbae928ae43312726c109cc9355e69616afe1e3aa6523371be1cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b39fe5d6727a654ba0b5750f461580d964364d5f5d8d830d5e84516077bfc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f121f0f9c0e573c1ec852e55cafdc6ed75a7a672d2ed88f95755f6e7ffd40b"
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
