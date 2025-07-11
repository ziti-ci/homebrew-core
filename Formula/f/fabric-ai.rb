class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.245.tar.gz"
  sha256 "4d0d56331e81a4294518e26bfe2cf26df4099d7ba4b7ee16007ac3e1f837b294"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de49b108c6e853900517ad475bf4d6af53337f8c967721d3a3b908b912a07c9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de49b108c6e853900517ad475bf4d6af53337f8c967721d3a3b908b912a07c9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de49b108c6e853900517ad475bf4d6af53337f8c967721d3a3b908b912a07c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "48689f350a0aa36ce266714edb226022c9e02232f6753f27c332cc8c51726a4b"
    sha256 cellar: :any_skip_relocation, ventura:       "48689f350a0aa36ce266714edb226022c9e02232f6753f27c332cc8c51726a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e66e5f466d10656e7561d48adfd09f677eebb5ce6ae15aa2c890a42ace945307"
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
