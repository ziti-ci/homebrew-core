class Lazyjj < Formula
  desc "TUI for Jujutsu/jj"
  homepage "https://github.com/Cretezy/lazyjj"
  url "https://github.com/Cretezy/lazyjj/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7bffeee7b5db5ae93f9a679d9a12f26b14f5b3e12a7825bd5596124e31070289"
  license "Apache-2.0"
  head "https://github.com/Cretezy/lazyjj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31a21d5ae014fcf22bdcc2a23967238c4a28507d7304ef5925d26d5de6d9eeb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae5384923a806a5390bc021f54eefb39301ea051be57344e140584e1aaa2352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13e4d591f14642e7f8b32039feea2333dfd5aa1e37c3c28809e2b5b225b52da3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ab52e8ab92e55bc98167c24178cf73c1ff487fa745a3280e5f3cb8fcc5c712"
    sha256 cellar: :any_skip_relocation, ventura:       "68f1a4806aa8ce2f8b16b410546f88f51836fe577ca9655a01f89aa496b620c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b500473b4ddfac36e2cdcdc26558d54b7b8ebe1d4566ded66311f9df94a8849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c1ee9cac680a4b7a18943c48f8c42756a8655555bfa00ca19c42c7ca58953a"
  end

  depends_on "rust" => :build
  depends_on "jj"

  # version patch, upstream pr ref, https://github.com/Cretezy/lazyjj/pull/164
  patch do
    url "https://github.com/Cretezy/lazyjj/commit/89505a3987825cd3f2c49deadc17c7f807e336e6.patch?full_index=1"
    sha256 "dd68657451c2a050d1b82034e1f21be93702f7600f08246d23fb6e74f6b58809"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LAZYJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}/lazyjj --version")

    output = shell_output("#{bin}/lazyjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath/"lazyjj.log"
  end
end
