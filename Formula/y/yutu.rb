class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "4b57f005467b9ac1606b80408b9a85287366619bb84e058dcb5d259047ae8950"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d96c6394fd2ad85aad33967c7796d1169dee67ec65c5466959fde92730f86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d96c6394fd2ad85aad33967c7796d1169dee67ec65c5466959fde92730f86e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93d96c6394fd2ad85aad33967c7796d1169dee67ec65c5466959fde92730f86e"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a4030ce0b519762770d82d1a85fef64af659e90f2b04bc0cf050983c0d56a6"
    sha256 cellar: :any_skip_relocation, ventura:       "19a4030ce0b519762770d82d1a85fef64af659e90f2b04bc0cf050983c0d56a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aee8a95b68bd3802e0ee086cf388792cf09bea9b957fbf38a1d515c984ca729"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[
      -s -w
      -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
      -X #{mod}.Arch=#{Hardware::CPU.arch}
      -X #{mod}.Version=v#{version}
      -X #{mod}.Commit=#{tap.user}
      -X #{mod}.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yutu", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yutu version 2>&1")

    assert_match "failed to parse client secret", shell_output("#{bin}/yutu auth 2>&1", 1)
  end
end
