class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.297.tar.gz"
  sha256 "a0eb52548ec1d151eef1c6d8f0a6e18a3fd6475411b7c76ff8ded6bb31d2dd97"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e925669f53b1615fd014d185a72013acc160854a6911e7af2560163c370138b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e925669f53b1615fd014d185a72013acc160854a6911e7af2560163c370138b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e925669f53b1615fd014d185a72013acc160854a6911e7af2560163c370138b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f0e6e284a441d17c671153642ff0fb7a92d5b10b9c0219b0b9b82deb8fdc3d"
    sha256 cellar: :any_skip_relocation, ventura:       "a2f0e6e284a441d17c671153642ff0fb7a92d5b10b9c0219b0b9b82deb8fdc3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e3c4b670ef63806d51bc7e38183b61f75c0af33b631256d7e0a3b1a4a9595b"
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
