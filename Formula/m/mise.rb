class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.8.4.tar.gz"
  sha256 "20fd1c91376305b0854f27f8cf180d3b0891e95da6b9967b6f5409b7ac9df6db"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93810068f5c5a5328e94e8fde4ee2eab8f58e9f723f209fcd796d8fb45598301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff233f8a9ce560c688b89313e07c96611e4f60d3aaa9c0aeea903af33405e28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95277a780e53011b4eb1eb60f696d00f2dc5521ef55b087b8bb681884a63990e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c439d9b66c08fadbeecc0e5610bde6c5144adba3ad1e3d6ca2cdf828fba6839"
    sha256 cellar: :any_skip_relocation, ventura:       "d85dfcfa65eb7a56d9b8b8614eb757152f57f36750859adeea9658826b57dce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8cc419b92807b3e9028a6bfa6f732587f92b89ffcce256c620d338e85d8555b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0e9be0852e7da7b96dbc617e1d6d20436efd07fe0aae7bc3f78376678e2ef7"
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
