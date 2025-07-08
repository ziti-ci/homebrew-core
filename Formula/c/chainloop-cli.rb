class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "c696db108c80f5f3923127bde0132ac63e7f9c1b2c1995fc2c7aaa2208290bcc"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3332b6e26f615b3a49aaf718c5dcdffacf4550e74e7dc7cb982d50f359085939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb39dca872f8cc6e3710ea5dcd43ae7e70d5adb5a2ceda56a919c87e72e0b164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20bdf2526ad9f8de9ffd7a86c29a5d5222c90dd4e269f8cdd04cdade6cf9af4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d169ac3f2c948ef3fd2df84d57681e046d14fe53b890f5e6584fa14b5156ea5"
    sha256 cellar: :any_skip_relocation, ventura:       "1a4fdf37de87c2d672f9a41196bdcef0ea5c0ca406fa4c0df063bc63fb71edd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3188d64f6fe412304f81a0ed85c7b885159dbc0c857f371d1b6e491306a02213"
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
