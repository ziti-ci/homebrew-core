class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.300.tar.gz"
  sha256 "2e9e9dbadb48fa97613cff4d912655f6777c397243ca1d086dc488beac73e733"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6fa30d5ae8e03f59ea6495190906715823d17e740f0145eb3c1eb34c136faa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e6fa30d5ae8e03f59ea6495190906715823d17e740f0145eb3c1eb34c136faa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e6fa30d5ae8e03f59ea6495190906715823d17e740f0145eb3c1eb34c136faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0be1f2c55d3364a2aaab5b89c989d08c41030c22902e4cc06b58374cf53fae8"
    sha256 cellar: :any_skip_relocation, ventura:       "d0be1f2c55d3364a2aaab5b89c989d08c41030c22902e4cc06b58374cf53fae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0a5e8cedfdefd03e02c20fae47d26f6a636c71e13c108babad2f27f159a924"
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
