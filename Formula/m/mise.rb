class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.10.3.tar.gz"
  sha256 "da66ee4393d8d724cc9e5529c74644f8ed90b1ec4706de994f3479624268f5bd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99acdcea5231afbb4b5fc225127e6fd716ebd8928b967d0d9dd2551fefe91cb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d4caaf62190e360c899db671a34f7c7d74de98507ddb68e970df4f9ebbef90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29dc132b39a885d4d29f86c85675677d74045d01665bf03ec7d8dd8794ebf401"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b124fd3086f80d3aefaa2311774f1e998c2b530179edf569723dcdcf1104f28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95259ad5e402476933ab82083d681d9486b7dc8923e1ace18a91ed0211e815cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0575aa68b94a49c2fd03d1d2143d5779caeaa23bc898a5e14a00af942f34037d"
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
