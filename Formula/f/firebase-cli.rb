class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.19.0.tgz"
  sha256 "daab1c4aa306133df5b87514ca8f0af9b1a75225d7e52256187923a7e22ce0ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db9d8e740bd078d3af3f7d4e23dd6e3b1d3bf0a5107c3452a75e1ded067b091e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9d8e740bd078d3af3f7d4e23dd6e3b1d3bf0a5107c3452a75e1ded067b091e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9d8e740bd078d3af3f7d4e23dd6e3b1d3bf0a5107c3452a75e1ded067b091e"
    sha256 cellar: :any_skip_relocation, sonoma:        "957c3d5e91f176487693f3a05c2b3ff8a40ca5f7d2e1dfea6d9a14cd7ac9268a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc664ab9696ea16416fdeba7bb92db386910fb0b77a266212ddc3f951a42db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777a102886cbcc9cc3cbbb81d185dec3c96b09d0ee9772a885f27d37323327d5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
