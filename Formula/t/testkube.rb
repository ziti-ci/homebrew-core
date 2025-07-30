class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6b78fd5e7b18e04ec88d538a6590a2c2fadf17979a3c39180193e420fa4bd776"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d40b35cb69c49311197464a02fbd1b77bef22eab563e5aed7ccf519b0dedb1b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40b35cb69c49311197464a02fbd1b77bef22eab563e5aed7ccf519b0dedb1b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d40b35cb69c49311197464a02fbd1b77bef22eab563e5aed7ccf519b0dedb1b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7264e807d228c5c669590dea97337ba5c199a54893c9364ec675020b8367809"
    sha256 cellar: :any_skip_relocation, ventura:       "d7264e807d228c5c669590dea97337ba5c199a54893c9364ec675020b8367809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d44f3936b70acea565c2af98325ce46348f7b444ee10470607a2ba4e4ab4aa4"
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
