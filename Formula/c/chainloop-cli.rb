class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "908edf4cdf47efd8c26a837e49e35c2da7f40be6f459e4a6ef1ff88de2e23153"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c72671677c11fd8363a559dfe4fdc9f54d09ca2ee313298cba62ccc61c8a894c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd3b77761f1815ef9d563336a03f3221d3d673a9d4f923ede621de3af12f3c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "138b6cb9493d07677ae1dd1f917b076ad25a71bbbe9c0fb1271bf2f9189476c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3efd0fe513bde48fa40266453fa84b1fddad17fcc20021c0eaf7a59225081d"
    sha256 cellar: :any_skip_relocation, ventura:       "82dde89cec8eb0d97f10d5edc7c08199db528f31bdd1ac165f094c19eeb2a100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a09e3838add892369fecbc818ee8f98e5a2c1be526dd1334c3c44b4846a4db2"
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
