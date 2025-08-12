class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.284.tar.gz"
  sha256 "2f4f1316ff61df382c7203aab0393e7fb7c4e36cf3229633be83a18be6af251e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79214428f882eea7fcb08ee5d88dc5e9321ebd657dd45289581fba9c1ffe626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79214428f882eea7fcb08ee5d88dc5e9321ebd657dd45289581fba9c1ffe626"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e79214428f882eea7fcb08ee5d88dc5e9321ebd657dd45289581fba9c1ffe626"
    sha256 cellar: :any_skip_relocation, sonoma:        "4deeb3ae60bad49ee90b6ece64f635f7ad3dfa2078a4bb6e19ea76b1a74a0a1b"
    sha256 cellar: :any_skip_relocation, ventura:       "4deeb3ae60bad49ee90b6ece64f635f7ad3dfa2078a4bb6e19ea76b1a74a0a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b8c0c6b9276c3e64692716e6116fbe3a75943ce582ece24091b3bfa739b34f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
