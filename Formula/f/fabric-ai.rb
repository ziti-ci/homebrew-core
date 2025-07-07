class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.237.tar.gz"
  sha256 "65eaca2d26350fc9bb3fff6422c5f74eff019b9bb43ccd8e36e9d883b633971c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097cbf6cba1a6a38bc2b76bd580d18b20094e1ec30772c66a8882f85419a3773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "097cbf6cba1a6a38bc2b76bd580d18b20094e1ec30772c66a8882f85419a3773"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "097cbf6cba1a6a38bc2b76bd580d18b20094e1ec30772c66a8882f85419a3773"
    sha256 cellar: :any_skip_relocation, sonoma:        "08dcdd56cfcb9f5bb010ff2eb19f3cad931fb739bcf88032792effeaf430674f"
    sha256 cellar: :any_skip_relocation, ventura:       "08dcdd56cfcb9f5bb010ff2eb19f3cad931fb739bcf88032792effeaf430674f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac62c329b64e9b5e452c71eeb8e0d1f0092ab33bfd4e56bf2b9648d914245fe1"
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
