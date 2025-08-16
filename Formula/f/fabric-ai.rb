class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.289.tar.gz"
  sha256 "5e0e0ba526d6f86db99ce87656ca03d49790ab756c41530bf27a260c93d27abb"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f86c23a5b3b25ae1abbd715ae510b406996c8911f0bfbf176f5d4a70c8a808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f86c23a5b3b25ae1abbd715ae510b406996c8911f0bfbf176f5d4a70c8a808"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52f86c23a5b3b25ae1abbd715ae510b406996c8911f0bfbf176f5d4a70c8a808"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c781fabfc9b5caa6b3aeb7b0710aabbdfe16865f3e0626ec536e7e5b434ac8e"
    sha256 cellar: :any_skip_relocation, ventura:       "6c781fabfc9b5caa6b3aeb7b0710aabbdfe16865f3e0626ec536e7e5b434ac8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06fb0be4bb9e159404d97c1259bd03c3868e99d680dc0b25c2bb7e3d212dc7d6"
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
