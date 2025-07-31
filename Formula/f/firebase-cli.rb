class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.11.2.tgz"
  sha256 "7560ac7334173e3194df9f6b41382f919b1bd3ec3e43285cc52ce14ebab8d96d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bac44d30fe12ae44dbcd5f7906df90441aea67e4f13e856d6a9b7d3f7d5c8765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bac44d30fe12ae44dbcd5f7906df90441aea67e4f13e856d6a9b7d3f7d5c8765"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bac44d30fe12ae44dbcd5f7906df90441aea67e4f13e856d6a9b7d3f7d5c8765"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d810e5018819cc08796a21d7bb629f1167c1dd6703eaec46ce6b1bc8f45173d"
    sha256 cellar: :any_skip_relocation, ventura:       "2d810e5018819cc08796a21d7bb629f1167c1dd6703eaec46ce6b1bc8f45173d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539fe033a336dcdc18b4b0c754ed3eb6575520b229fddee3316631eee8e17138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b2554692f9cbf02ff9b93950d5edc99b8cf4f4fa5115313c8285fb6d30fa7ad"
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
