class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.239.tar.gz"
  sha256 "1e08463e3d2abfc6bbaf820d96da8b13179c5c68c6b30459ac6da23d506c3bb7"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c82c9660127476d7483953ff19df65fb8e9e364f8cc3126a9bf91435de6e3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c82c9660127476d7483953ff19df65fb8e9e364f8cc3126a9bf91435de6e3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1c82c9660127476d7483953ff19df65fb8e9e364f8cc3126a9bf91435de6e3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c3df83c7d4e4817dc56fab2141db4d70a876674128f267a86104edf220a871"
    sha256 cellar: :any_skip_relocation, ventura:       "99c3df83c7d4e4817dc56fab2141db4d70a876674128f267a86104edf220a871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a74f47896279a88f7930f74fef4774ce029ad2f3aaa33a20add7184662458dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
