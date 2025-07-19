class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-8.2.2.tgz"
  sha256 "fa9f73300d2e9d9fe994f3f39ee43ea31f6512f2eee14c8ab8247360d06eeb2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d63e76c5f79f34c9919fb75beda4688ec49c4955c4f2be7a541a57eaeeb7ae79"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Ensure uniform bottles
    inreplace [
      libexec/"lib/node_modules/appwrite-cli/install.sh",
      libexec/"lib/node_modules/appwrite-cli/ldid/Makefile",
      libexec/"lib/node_modules/appwrite-cli/node_modules/jake/Makefile",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
