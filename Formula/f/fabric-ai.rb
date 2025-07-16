class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.253.tar.gz"
  sha256 "86a991424ec68ef98a14c93a27b51dc06a0d9ade6aaa188594fa8d3eb99d09ab"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e22b5d8438696886e35303d3e0ed00a02ac90efe5db35f5bca5f9cb1bf9d577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e22b5d8438696886e35303d3e0ed00a02ac90efe5db35f5bca5f9cb1bf9d577"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e22b5d8438696886e35303d3e0ed00a02ac90efe5db35f5bca5f9cb1bf9d577"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f8e7d3287cf711013a466e74504f21216c301fa1f944a235d551fc03af4d937"
    sha256 cellar: :any_skip_relocation, ventura:       "1f8e7d3287cf711013a466e74504f21216c301fa1f944a235d551fc03af4d937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de38a0ab7d45d63bed2dbe3fa2143eade4d82e93d199bba561990bde5e0b860f"
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
