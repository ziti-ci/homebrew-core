class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.290.tar.gz"
  sha256 "c6f71fa8f5d6ef665ebae3560c589ab95326880764957ffe5a7a396a97d64145"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd3c89b3de430b2404a65aa3c57b8f3f9b0553618621e37e1f7f334b28705e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd3c89b3de430b2404a65aa3c57b8f3f9b0553618621e37e1f7f334b28705e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fd3c89b3de430b2404a65aa3c57b8f3f9b0553618621e37e1f7f334b28705e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ac2731311cc1e47730040be40d99ac69a8dcbc497892006b1a57a1a66c344b8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ac2731311cc1e47730040be40d99ac69a8dcbc497892006b1a57a1a66c344b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3c8641b24a62150d31bcede44f1a914850e2cbfce6904b4b053ca487b60aee"
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
