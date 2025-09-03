class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.43.2.tar.gz"
  sha256 "c4c771bc11739fcffbf4c2ccdf1b222a88377a59d10ad1276aaca9d91d80d9e7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b02f4d546d4ea79b7caef039e22a35875e255766e05754e217a8eb5551194cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b10aa5f0c868d7d9026aa22f46f24eb50e1923d5ed6706c2b26702c25c50f2f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c4de59a65746e3553c5a4f018058ee2f79dbd2cdf892b303d5cc146454c1d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bf10db89fe1ec89ba9175baab1ba7703d992b407e4b14a6c5d14efcb001f466"
    sha256 cellar: :any_skip_relocation, ventura:       "7d803c5fa43a22d8c207653c7e620041791803db8f34e0e4a37f9986ea3a0328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc3a5b3329cc4946150edd108c1aa2ca8a06cc96962a03067d2a3df0a34f780"
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
