class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "54a936519598d52136e69b9cb523c963945ac4db8a6811f477b70dd005d7c26e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10090ec18ab1897a40fac4b4075fa7365f5351a2b91a0cfe1a8210a13ff96812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f58be5a2215e1cdb087a5955220eb708716ce3331085522956a86d3d660f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f58be5a2215e1cdb087a5955220eb708716ce3331085522956a86d3d660f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45f58be5a2215e1cdb087a5955220eb708716ce3331085522956a86d3d660f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b46b0e4cafdbc3fb75297cf5e4bb62319d9e28831f0ff4ca3b3c6df7cdef48b"
    sha256 cellar: :any_skip_relocation, ventura:       "0b46b0e4cafdbc3fb75297cf5e4bb62319d9e28831f0ff4ca3b3c6df7cdef48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c458a8a916d23ff77e466897d010ab72cca1f616db0a5b90671fb268e7e25b2f"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
