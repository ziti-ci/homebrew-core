class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu.git",
      tag:      "v0.10.1",
      revision: "16f8f0e9b996a2804263f9e4a709101a76517bc1"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6379dfa432ab78de09e8f57ac788033cc60b4563954d3eedab897182135d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6379dfa432ab78de09e8f57ac788033cc60b4563954d3eedab897182135d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6379dfa432ab78de09e8f57ac788033cc60b4563954d3eedab897182135d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ffb38dcb261f787f7db6f486a423fd365489da3907d4f71e6be342eb8408a01"
    sha256 cellar: :any_skip_relocation, ventura:       "0ffb38dcb261f787f7db6f486a423fd365489da3907d4f71e6be342eb8408a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9425e2e6983e47c468b763c5ab598a6007a47e064838074b58f5c53ef59a63a"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[
      -s -w
      -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
      -X #{mod}.Arch=#{Hardware::CPU.arch}
      -X #{mod}.Version=v#{version}
      -X #{mod}.Commit=#{Utils.git_short_head(length: 7)}
      -X #{mod}.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yutu", "completion")
  end

  test do
    assert_match "yutu🐰 version v#{version}", shell_output("#{bin}/yutu version 2>&1")

    assert_match "Please configure OAuth 2.0", shell_output("#{bin}/yutu auth 2>&1", 1)
  end
end
