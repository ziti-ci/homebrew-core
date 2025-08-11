class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.282.tar.gz"
  sha256 "fb6f15a4aacf829980ba09184d54b3aad9c2642554516e1846d026010a7bb527"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e75e4e81275159a7b1ca195ba1a397be870eb0ee6224c420be02d125b11c0258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e75e4e81275159a7b1ca195ba1a397be870eb0ee6224c420be02d125b11c0258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e75e4e81275159a7b1ca195ba1a397be870eb0ee6224c420be02d125b11c0258"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c110e8927539234a68783c033230d954acd026037e3ca5b15ec92b3195f1bc8"
    sha256 cellar: :any_skip_relocation, ventura:       "7c110e8927539234a68783c033230d954acd026037e3ca5b15ec92b3195f1bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d6023bfe168f4a8963b5f201dac5af929fa5f64cd6103afec62283cf3093ff6"
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
