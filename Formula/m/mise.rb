class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.7.25.tar.gz"
  sha256 "47ffc0df773862ba207027f71d90f97067f7c896c3c4d82f07abf9a180f2bbeb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6ee09dfc8956c9d4941142c34beaa9c684b3921b3ff4cb7021066e3b6d7ccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213d03502733832a73316d7e5f8016a336dbd8eec024a20b6138d46ee6719bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32c95a09b72d6cdff84af1267164710a875e289181fcbbe860ce88c2c80f3b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86dfe7dbb2e64ee8ea3eb323604b52d0645f1e29b303a8220e6919699b02df1"
    sha256 cellar: :any_skip_relocation, ventura:       "c03c5cf0ad2f8015aef28c11196a63036b51c09b8942a5360ef3ac16390ba582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e82b485d08bbacfd625d323b10d3023e2dd72fa11b2b4a1d30bdaae01760523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d76447d0ca60e5f4a04680636620861a8aed3790e02bff134d7430e3052cf78"
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
