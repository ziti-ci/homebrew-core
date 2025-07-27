class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.269.tar.gz"
  sha256 "840c08671ab7bdb864b63c8cd565ca073a0c4f9ee9f9af06e8044e19f4d5d0ea"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "160c46dc87e21667709896930f0b1f37e62ac832e08130331ec9037e5cbc074a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160c46dc87e21667709896930f0b1f37e62ac832e08130331ec9037e5cbc074a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "160c46dc87e21667709896930f0b1f37e62ac832e08130331ec9037e5cbc074a"
    sha256 cellar: :any_skip_relocation, sonoma:        "857c52617c8041ee95568e05d1da11e179253e1682267fbd4ccae461945e7d71"
    sha256 cellar: :any_skip_relocation, ventura:       "857c52617c8041ee95568e05d1da11e179253e1682267fbd4ccae461945e7d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26cd42c14715ab876a2859e3f0f65a370d850c52c2041697fd9bf987f2439279"
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
