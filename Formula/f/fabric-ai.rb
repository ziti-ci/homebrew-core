class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.301.tar.gz"
  sha256 "0a3b759dce9f8c9fee745eb16574fedaf5a93aefe446ad015cc6fd21e8b87490"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d93f3e67153987d90e015604d49e0db1751e0fedeec1147cf7941d95e927be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d93f3e67153987d90e015604d49e0db1751e0fedeec1147cf7941d95e927be1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d93f3e67153987d90e015604d49e0db1751e0fedeec1147cf7941d95e927be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0dcf62c7f5bb3b110b562644c56ee318d4f83081849296aabd9431b78601397"
    sha256 cellar: :any_skip_relocation, ventura:       "c0dcf62c7f5bb3b110b562644c56ee318d4f83081849296aabd9431b78601397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56e6f806f88b03883d5ed914832bc24488ce5d12c5f7ecec65e83e93705c9a5"
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
