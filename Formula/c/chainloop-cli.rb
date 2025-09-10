class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.2.tar.gz"
  sha256 "1cf4b843e37e40a6a4fbacab92e0e75ca9588fdd3ff65d12e5bb83980bf074fa"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2245cded315048525d462ddc5f77ed50e94855709930da0f79cbe87709c3c34d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0777743d6ec6b8189290b6448950a3412de30454fde4610043a8143e03c570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07dec2d983f9df88d3442df21945f0484a50360c7e9710bbe13a4de921539f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "232a9472e8b6867b36d03451b312f7f72bff5ffbdd6283dddddaa90e6a9c45f8"
    sha256 cellar: :any_skip_relocation, ventura:       "9d4aae787c5295453462501ddb8dfbc20dd14ba1f1192c34473c137cd2d62c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94782fcc33a1026ef7f52a51288a8285ed8f46963cb82bbeee678f9172ae4716"
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
