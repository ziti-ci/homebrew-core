class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.274.tar.gz"
  sha256 "67479d72ef11487f5990ea1439f2a4cdc6229a1bce6d6b9b9b8d22f51f1b8755"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28555df2ec15fb544c63c2100bd820a169e6a9b99e16387c410b62a733da2d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28555df2ec15fb544c63c2100bd820a169e6a9b99e16387c410b62a733da2d96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28555df2ec15fb544c63c2100bd820a169e6a9b99e16387c410b62a733da2d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38d1718bc821f44756d27995b179d7c11f2ed3c5d70588c04e78b4689497967"
    sha256 cellar: :any_skip_relocation, ventura:       "a38d1718bc821f44756d27995b179d7c11f2ed3c5d70588c04e78b4689497967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658771b6ec13120a57aac44f40457d8605aaccdefdf07ddbcc0407b6c596f03e"
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
