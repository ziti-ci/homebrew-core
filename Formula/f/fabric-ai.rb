class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.310.tar.gz"
  sha256 "dc50ef6ac8211c88bdf82afffccb0ef996e25b746c5be96755bb2cbc94108273"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a1b51676b60aca1f9a780820f4686e325475d8b5ffad610ccdc8c1506201cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a1b51676b60aca1f9a780820f4686e325475d8b5ffad610ccdc8c1506201cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11a1b51676b60aca1f9a780820f4686e325475d8b5ffad610ccdc8c1506201cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f6b7e5d0fe6f8cd9a0580dd3547ab5fe09c8377f074d11a02c3f0290786b397"
    sha256 cellar: :any_skip_relocation, ventura:       "8f6b7e5d0fe6f8cd9a0580dd3547ab5fe09c8377f074d11a02c3f0290786b397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b19fcc5dd494306f0d91eeba550a62f0cc7c129041be1671c6eade5dc560aed"
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
