class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "74e261e783fa79c458295c619fb910179956e6ad87055f26b177511a645eb74d"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3890b1663595d3b4d9040a12e88ae473315f5c6bd71df7367ff56f2c746e3c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "867e1e2001e32f9036d567a9a46f2bb181fd7c7167832fa1d8850072909b29d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1618e513154d7c1a422a7bbca1cec701b9924bbe8fc98a8b63e05e209edb3684"
    sha256 cellar: :any_skip_relocation, sonoma:        "4439bec95695b80d87170e26b18722b99bde517cc8dcc6fcc369159e0efcd915"
    sha256 cellar: :any_skip_relocation, ventura:       "c012e1c0a291ab91f763a81c2aa879454273cb74c3221cd204c3a2beafc81b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94eb2251c917dec1604f95206cedd1dc0bb51c66dc75199f8685e4c5472e6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc29d05da03a3a5724108bbe398c9c443a0d7e2a52c6b395830614f2e5df0f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
