class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.307.tar.gz"
  sha256 "f90fb73025941d31a3b742c1600c5d9fae870dde46fd41a1def49dfc28d000e2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b7b348836612e78f32a685d1d7d8012742472c920fde093fa4b07589ee2eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4b7b348836612e78f32a685d1d7d8012742472c920fde093fa4b07589ee2eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4b7b348836612e78f32a685d1d7d8012742472c920fde093fa4b07589ee2eb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be32c55bcdb3f886920971292fa0ff47efbb3a4fc7f0aad5f400101431c951a"
    sha256 cellar: :any_skip_relocation, ventura:       "9be32c55bcdb3f886920971292fa0ff47efbb3a4fc7f0aad5f400101431c951a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52f01bafcdaf541811f5064e38d16cd07ba4a1c46b507e2c86346c24cab84e3"
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
