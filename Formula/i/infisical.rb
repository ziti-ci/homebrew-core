class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.11.tar.gz"
  sha256 "b44fa0b8e12bd7aa302528b0ed4aafd7a9c0d78aea0c5e7dcf2d589e8eefb35c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65e2804069f8f0b49b6c728fe1bbc8a55c5ff23d8d126f6f89e9a4f02b23acc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e2804069f8f0b49b6c728fe1bbc8a55c5ff23d8d126f6f89e9a4f02b23acc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e2804069f8f0b49b6c728fe1bbc8a55c5ff23d8d126f6f89e9a4f02b23acc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1570442e6294a95e93a3003b67750b3a405518f82fdd3a251692282af261d1ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f804ad84e10bff713d1e82894d81304dcced42a6475fede0b506e729046fb355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55527c1949a64b4468b99491569092eba260dc8b0d54dad00c339b83f91682f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
