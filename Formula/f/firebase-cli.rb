class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.13.0.tgz"
  sha256 "d2bf03f06874bab6251c00e098ee567e48ab8857a6c8bbaabf60699558ee8268"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc32ba3623699e4faadd96fc9f20dd36f527a39b90ce202394eaa32d1226424f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc32ba3623699e4faadd96fc9f20dd36f527a39b90ce202394eaa32d1226424f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc32ba3623699e4faadd96fc9f20dd36f527a39b90ce202394eaa32d1226424f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4887feb2bbc68f7766273a2f7ff99f23e7bc13955e9f58715f0652c9a66e2fc9"
    sha256 cellar: :any_skip_relocation, ventura:       "4887feb2bbc68f7766273a2f7ff99f23e7bc13955e9f58715f0652c9a66e2fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58acd98b566117b985a4d42881a58c4834acde23e0e2b8e72bd95ed76726dae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb6423054517d90d03584dc790bdabaef77102da3946440e3f225b1e37379e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = shell_output("#{bin}/firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end
