class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.235.tar.gz"
  sha256 "e2591bc7c8664b07bf721d611c1da249bf020721e20cbbfb008709341a7bf178"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902e2fb01fb9d4ac23892904a5b880ddfe8b0b133c9c196f3d5fe5397b2cd06b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902e2fb01fb9d4ac23892904a5b880ddfe8b0b133c9c196f3d5fe5397b2cd06b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "902e2fb01fb9d4ac23892904a5b880ddfe8b0b133c9c196f3d5fe5397b2cd06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bf140c60c7fb88f06c8af285a54aef5acc1f2310171d487a97d992c97e541da"
    sha256 cellar: :any_skip_relocation, ventura:       "8bf140c60c7fb88f06c8af285a54aef5acc1f2310171d487a97d992c97e541da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "047df9c690c792cf6be05b329135ae34ce7ec794d76c0cbd96df526323e60fd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
