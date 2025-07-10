class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.10.0.tgz"
  sha256 "7e3a35cb04be3cd30d4ef5d24b5202ec90777e56be59beda4365c4bf4c520675"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878e877dc29ceed1838128678a08f80e0753265ffe1732a12e13395da5d2f179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878e877dc29ceed1838128678a08f80e0753265ffe1732a12e13395da5d2f179"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "878e877dc29ceed1838128678a08f80e0753265ffe1732a12e13395da5d2f179"
    sha256 cellar: :any_skip_relocation, sonoma:        "91cfac2b2bb21c9781955f79245410a731e0ff4645b152ebb923190392641956"
    sha256 cellar: :any_skip_relocation, ventura:       "91cfac2b2bb21c9781955f79245410a731e0ff4645b152ebb923190392641956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db554199b8a55bad99d2de97a05d62cbb7fdb96d0aad613d0a9e9316777e6a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba7941137ba9b035f4f794fe85041d2b4531523f61646ed72eef3347845680fc"
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
