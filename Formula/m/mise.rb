class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.7.27.tar.gz"
  sha256 "5570cef677c5759fa7da6f961b58dcab37615a939f2738748af4d8ad86df921f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8918169e56d839856bd58321075babc6e97b68be0272b2919fb8757b951ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6bff43d145c85afbf9ad4857b9ce1c8c5d8fd938e1d62de15db933f58d0b2d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d614d00f6596d95ca63ffefad09bc098d5c743f9f604fd47491c59abf8350d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac191ae26d898eb2cc8df1924794057b3ffa431d4870f02a95be3847b8019ed6"
    sha256 cellar: :any_skip_relocation, ventura:       "613f52cea0dea9497f42caac8daebc74f394aa213da39c824b6e7f68d57059cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8139c84446c10d3aec34cf7c0b39357cd450c867efce9e83ee62fad287509516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b0748a6f429548d431aebb9836405f7e531ea19c44086bea527d2dbda926b1"
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
