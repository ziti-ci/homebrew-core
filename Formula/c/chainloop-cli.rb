class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "7748afa575ca463f3378fb6cba783757dd2287cd99bcecef3dce60f11813a409"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4da4897560669fad71283d727e2ffcd527138a6f5d8fa3923201f48345c4a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "893e40d07ec551226046ec36d1fe8695e00332edd979b8c23179e95c0cc731d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cca3c9d0e67267fc046156100b2510bc4ec79f178cdcc7247b4d5bf1aea41ba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "54e53798a2d8f78e907e7ea3cc5a1d6863ea4505c830fe8fe9abd4d9ecd14cf4"
    sha256 cellar: :any_skip_relocation, ventura:       "6ae7b12a693c9c5aa7e85ee7ad8218b0f65dda36c4bf76d706f6ffaad55fc048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1ac436e5a0dad102aad926a775f6daa051a3fa3f0c073b5df82bc4fd9af9b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
