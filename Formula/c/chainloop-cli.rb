class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "4f022b7c00e402abc9e575480bb4ef1f8d04e3b84e489f6d9dada45b8ebbf603"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f66db6febe124916490ff72be64c22041837433e2ee198f095848e1e2a0fe39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7047e9e99b35c29781b07cc91da65cdaeafa26ffb897d33b5a2c26423570984a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9eedeff69cdbbb2650379c24089a2b2eb5230aa8727b66d178cf734304263eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea12f16bd036665dae918e9afc8ed9d53b0f3dcb4bea508428db9b930b90293"
    sha256 cellar: :any_skip_relocation, ventura:       "46b008020aa4665bd5f079d1dc8a58f2673dab2e643d9ddc836938f4e98fe072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5d8dd75ccc4f5e19a143a5d4b1c447b75b354ba5d898a6163007fa14b01e4a"
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
