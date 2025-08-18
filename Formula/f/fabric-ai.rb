class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.290.tar.gz"
  sha256 "c6f71fa8f5d6ef665ebae3560c589ab95326880764957ffe5a7a396a97d64145"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb44d5adc0635965f1dedaf6417a8c30d9fe2351ead889e095ce1b7e62bc3a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb44d5adc0635965f1dedaf6417a8c30d9fe2351ead889e095ce1b7e62bc3a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb44d5adc0635965f1dedaf6417a8c30d9fe2351ead889e095ce1b7e62bc3a04"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a5bf44dc4ef1beafe5f290cbad46d0d3faf566c4d711f00782116b6ff81a11"
    sha256 cellar: :any_skip_relocation, ventura:       "79a5bf44dc4ef1beafe5f290cbad46d0d3faf566c4d711f00782116b6ff81a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79679552000611c1b45fe0bb747fe7442de79d35d71b6edb65811717c1d6a72a"
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
