class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.19.1.tgz"
  sha256 "011450a07d686d2b17438ae9f290ba14780503f17178290b863ce550566aa042"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f4b0c332f9b2a1cfca082e163a0ad5fee6e8cde6cd324f3b996e51e1a7a26db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f4b0c332f9b2a1cfca082e163a0ad5fee6e8cde6cd324f3b996e51e1a7a26db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f4b0c332f9b2a1cfca082e163a0ad5fee6e8cde6cd324f3b996e51e1a7a26db"
    sha256 cellar: :any_skip_relocation, sonoma:        "1929c763a2a7f8c1c63293a9c81a195d01565267f263d37f1bfaad7ec3d9644b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b83d4ef34193ec6ab8da47df8b7ddbdb45e78a6b6ac3181cfeaf27361d0ee71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6114856354e7bde5c7fd8636cf0d5c645d1aa4a4f3c94419c851a888fe4e7d"
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
