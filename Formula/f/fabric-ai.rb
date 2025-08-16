class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.288.tar.gz"
  sha256 "aae6975574847c75249efa1a316c5127d01f06e4e80e37d62cadd45808afcaa0"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bbcaf005481f95bf44e246c2ec7d30c3b5444c181289a863bcfd771ef84742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94bbcaf005481f95bf44e246c2ec7d30c3b5444c181289a863bcfd771ef84742"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94bbcaf005481f95bf44e246c2ec7d30c3b5444c181289a863bcfd771ef84742"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4060bcecb5ad710d2a0c9bfdac981d717861b53bf7c1e48a8d9b884b762d896"
    sha256 cellar: :any_skip_relocation, ventura:       "b4060bcecb5ad710d2a0c9bfdac981d717861b53bf7c1e48a8d9b884b762d896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51c227d3078b799b0b70aa8c4153429861a279c6aa18c96c0afdfb369ff7d23"
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
