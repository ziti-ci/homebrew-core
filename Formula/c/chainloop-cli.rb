class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "880f4983cafe85e3dfe4b017ff415e05dd2e7d665b3de6cb90ceb0011bd8f465"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66224b43097cd8b3bad09ed73d4023c0dfb948fb19d22990f0af875b09a138af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5467c1ae95308563c0d9d4dc3ab1b955da301cf6addf90d35c365edb9c827cb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0236bc4a4ac9b5dd51859eb7366df1203d9da18cac708af5761d8e244f7510a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc25117ac9dc045f3b1539697ed0fa47650e0cb9ddf8e8b2846266daec27367"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0a0f22dce2782e9aae07b7381bdd1ab5e5dbdda8c7f506e1b477953181283a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72d974b35dcb02e5fff9f30cd24c86911422f32b361da30e1c2995d0df546cb"
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
