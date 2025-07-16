class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.255.tar.gz"
  sha256 "8be6cbd4e0f6f49ec05bc09f77164449396b83be789c68ee6642a3422ba3a0c2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3f885ed80ca6a77f6d6b05bd1ac385c34fe8ac7b4d387e2dc504e5ca1d55a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3f885ed80ca6a77f6d6b05bd1ac385c34fe8ac7b4d387e2dc504e5ca1d55a4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3f885ed80ca6a77f6d6b05bd1ac385c34fe8ac7b4d387e2dc504e5ca1d55a4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83ac9bcfb07eb11c8e455b2f145f15b8d6a0e99c0b977118ca667decc89426a5"
    sha256 cellar: :any_skip_relocation, ventura:       "83ac9bcfb07eb11c8e455b2f145f15b8d6a0e99c0b977118ca667decc89426a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "092409986fe39f5a80e9ff07013f4c3891f425e81e7d61dd8aee5cc437892c01"
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
