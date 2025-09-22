class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.317.tar.gz"
  sha256 "d71ade430e4233dc71825bf43d85271d8f43848a0a03de03d54236ed0b9e4b87"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8b71d2364d158c86cbf80fe98b48394df6e59fa792929e7b9f42a5d2f1faefd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b71d2364d158c86cbf80fe98b48394df6e59fa792929e7b9f42a5d2f1faefd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b71d2364d158c86cbf80fe98b48394df6e59fa792929e7b9f42a5d2f1faefd"
    sha256 cellar: :any_skip_relocation, sonoma:        "81771c6a743b91516b66e42d301f9cdefbb568db294227e84f3f547ec1282fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98169be82ae806461dc69628e5e48738bb9221c484d7608c1f48f9f95dcb34f"
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
