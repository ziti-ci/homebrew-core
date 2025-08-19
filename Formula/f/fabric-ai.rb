class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.292.tar.gz"
  sha256 "7777bdd584f13c5a470f3d053849b236a1174890a72d98526d12db54204b04cd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca0c18b162a41a77e91b47262a1a248ebc4c9e3582452b3776d405aad876713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca0c18b162a41a77e91b47262a1a248ebc4c9e3582452b3776d405aad876713"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cca0c18b162a41a77e91b47262a1a248ebc4c9e3582452b3776d405aad876713"
    sha256 cellar: :any_skip_relocation, sonoma:        "071afb86ed7f86d10264916ac2c13e1686e88d084c6954d4788ee1ce8ca68dbc"
    sha256 cellar: :any_skip_relocation, ventura:       "071afb86ed7f86d10264916ac2c13e1686e88d084c6954d4788ee1ce8ca68dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93150306716c965601cd0b774496e09fd3b7a717dc31e64845e6aecddd4558b9"
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
