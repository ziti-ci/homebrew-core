class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.299.tar.gz"
  sha256 "8577a91da83d16ea35da485c8d8e45387b343291af41a1ebfd69438ab6760dcf"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cc21548c4949cb93cbe5fb1b6752af8b2e528fe433e94f4012e5f14520d8e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cc21548c4949cb93cbe5fb1b6752af8b2e528fe433e94f4012e5f14520d8e6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cc21548c4949cb93cbe5fb1b6752af8b2e528fe433e94f4012e5f14520d8e6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a32f7d1500c70982aa11ebfec8d54202c629fb05c1941b7db57ec9b142425c6c"
    sha256 cellar: :any_skip_relocation, ventura:       "a32f7d1500c70982aa11ebfec8d54202c629fb05c1941b7db57ec9b142425c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f0bb32adbb221e735410883fae34afc5ed2ab7e78f761c5b5a40fe5b9e26ae"
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
