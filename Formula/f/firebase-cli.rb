class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.12.0.tgz"
  sha256 "811a9eb0621e95d062b09d119527771eb0703993ea0251fdd3a0fa9382f58aed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c01f0f101db930b276c36c35077ee3a2b627e8350f28ac7b3a375c222091d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c01f0f101db930b276c36c35077ee3a2b627e8350f28ac7b3a375c222091d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1c01f0f101db930b276c36c35077ee3a2b627e8350f28ac7b3a375c222091d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "add709bbbb69854f551135fc6c06e83a78c5ed1f3ac729e35d2f46181e3d0524"
    sha256 cellar: :any_skip_relocation, ventura:       "add709bbbb69854f551135fc6c06e83a78c5ed1f3ac729e35d2f46181e3d0524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "199a22bd7179be85fe6bde078c4756e1271ba27452add396fc705bc5725082f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa660f14f194022e76dadf3c808ee58f98046a9752897ba5e1268b12e4059dd1"
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
